const { functions } = require("../firebase_admin/index");
const teller = require("./teller_api");

module.exports.tellerEndpoint = functions.https.onCall(
  async (data, context) => {
    // if (context.app == undefined) {
    //     throw new functions.https.HttpsError(
    //         'failed-precondition',
    //         'The function must be called from an App Check verified app.')
    // }

    const msg = data.msg;
    console.log(`tellerEndpoint msg: ${msg}`);

    switch (msg) {
      case "getAccounts":
        return await getAccounts(data);
      case "getTransactions":
        return await getTransactions(data);
      case "removeAccount":
        return await removeAccount(data);
      default:
        return null;
    }
  }
);

async function getAccounts(data) {
  return await teller.api("GET", data.accessToken, `accounts/`);
}

async function getTransactions(data) {
  var transactions = await teller.getAllTransactions(
    data.linkedAccounts,
    data.date,
    data.userId
  );
  transactions = JSON.stringify(transactions);
  return transactions;
}

async function removeAccount(data) {
  return await teller.removeAccount(data.accessToken, data.id);
}
