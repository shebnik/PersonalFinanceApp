const teller = require("../teller/teller_api");
const { functions, db, Timestamp } = require("../firebase_admin/index");
const { sendEmailDailyReport } = require("../sendgrid");

function getYesterdayDate() {
  var date = new Date();
  date.setDate(date.getDate() - 1);
  date = date.toISOString().slice(0, 10);
  return date;
}

module.exports.tellerGetYesterdaysTransactions = functions.https.onRequest(
  async (request, response) => {
    const yesterdayDate = getYesterdayDate();
    console.log("[GetYesterdaysTransactions] yesterday date: ", yesterdayDate);

    const todayTimestamp = Timestamp.fromDate(new Date());
    const users = db.collection("users");

    var querySnapshot = await users
      .where("trialEndDate", ">", todayTimestamp)
      .get();
    for (var doc of querySnapshot.docs) {
      await updateTransactions(doc, yesterdayDate);
    }

    querySnapshot = await users
      .where("stripeInfo.status", "==", "active")
      .where("trialEndDate", "<=", todayTimestamp)
      .get();
    for (var doc of querySnapshot.docs) {
      await updateTransactions(doc, yesterdayDate);
    }

    response.send();
  }
);

async function updateTransactions(doc, date) {
  const user = doc.data();
  const userId = user.userId;

  const transactions = await teller.getAllTransactions(
    user.linkedAccounts,
    date,
    userId
  );
  if (transactions.length == 0) return;

  const transactionsRef = db
    .collection("transactions")
    .doc(userId + ":" + date);

  await transactionsRef.set({
    date: new Date(date),
    transactions: transactions,
    userId: userId,
  });

  await sendEmailDailyReport(user, transactions, date);
}
