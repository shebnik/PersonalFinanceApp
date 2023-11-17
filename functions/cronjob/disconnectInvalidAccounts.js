const { functions, db, Timestamp } = require("../firebase_admin/index");
const {removeAccount} = require("../teller/teller_api");

module.exports.tellerDisconnectInvalidAccounts = functions.https.onRequest(
  async (request, response) => {
    var startAt = new Date();
    startAt.setDate(startAt.getDate() - 1);
    startAt.setHours(0, 0, 0, 0);

    var endAt = new Date();

    console.log(`startAt: ${startAt}\nendAt: ${endAt}`);

    var querySnapshot = await db
      .collection("users")
      .where("stripeInfo.status", "==", "inactive")
      .orderBy("trialEndDate")
      .startAt(Timestamp.fromDate(startAt))
      .endAt(Timestamp.fromDate(endAt))
      .get();

    for (var doc of querySnapshot.docs) {
      const user = doc.data();  
      for (var i in user.linkedAccounts) {
        const linkedAccount = user.linkedAccounts[i]
        await removeAccount(linkedAccount.accessToken, linkedAccount.id);
      }

      await doc.ref.update({
        linkedAccounts: [],
      });
    }

    response.send();
  }
);
