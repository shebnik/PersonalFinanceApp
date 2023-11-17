const https = require("https");
const fs = require("fs");
const fetch = require("node-fetch");

const tellerURL = "https://api.teller.io";

module.exports = {
  api,
  getAllTransactions,
  fetchTransactions,
  removeAccount,
};

async function api(method, accessToken, path) {
  const url = tellerURL + "/" + path;
  console.log("[Teller] api url:", url);

  try {
    // TODO: Add your own Teller certificate and private key
    const httpsAgent = new https.Agent({
      cert: fs.readFileSync("teller/cert/certificate.pem"),
      key: fs.readFileSync("teller/cert/private_key.pem"),
    });

    var headers = new fetch.Headers();
    headers.set(
      "Authorization",
      "Basic " + Buffer.from(accessToken + ":").toString("base64")
    );

    let response = await fetch(url, {
      method: method,
      agent: httpsAgent,
      credentials: "include",
      headers: headers,
    });

    if (response == null) return;

    let data = await response.json();
    if (data != null) {
      return JSON.stringify(data);
    }
  } catch (e) {
    // console.log(e);
    return null;
  }
}

async function getAllTransactions(linkedAccounts, date, userId) {
  var transactionList = [];
  var count = 0;

  for (const account of linkedAccounts) {
    const accessToken = account.accessToken;
    const accountId = account.id;

    const transactions = await fetchTransactions(accessToken, accountId, date);

    count += transactions.length;
    transactionList = [...transactionList, ...transactions];
  }
  console.log("Total transactions count for userId: ", userId, " = ", count);
  return transactionList;
}

async function fetchTransactions(
  accessToken,
  accountId,
  date,
  foundDate = false,
  from_id = null,
  transactions = []
) {
  var response;
  if (from_id == null) {
    response = await api(
      "GET",
      accessToken,
      `accounts/${accountId}/transactions?count=20`
    );

    var requestedDate = new Date(date);
    console.log("Requested transaction date: ", requestedDate);

    var firstFoundDate = new Date(JSON.parse(response)[0].date);
    console.log("First first found date: ", firstFoundDate);

    if (firstFoundDate.getTime() < requestedDate.getTime()) {
      console.log(
        "The first transaction date must be bigger than today date (No transactions for now)"
      );
      return [];
    }
  } else {
    response = await api(
      "GET",
      accessToken,
      `accounts/${accountId}/transactions?count=20&from_id=${from_id}`
    );
  }
  var responseTransactions = JSON.parse(response);

  for (var transaction of responseTransactions) {
    if (transaction.date == date) {
      foundDate = true;
    }
  }
  if (!foundDate) {
    from_id = responseTransactions[responseTransactions.length - 1].id;
    return await fetchTransactions(
      accessToken,
      accountId,
      date,
      foundDate,
      from_id,
      transactions
    );
  }

  var filteredTransactions = responseTransactions.filter(
    (transaction) => transaction.date == date
  );

  transactions = [...transactions, ...filteredTransactions];

  if (responseTransactions[responseTransactions.length - 1].date == date) {
    from_id = responseTransactions[responseTransactions.length - 1].id;
    return await fetchTransactions(
      accessToken,
      accountId,
      date,
      foundDate,
      from_id,
      transactions
    );
  }

  console.log(
    "Found ",
    transactions.length,
    " transactions for date: ",
    date,
    " for accountId: ",
    accountId
  );
  return transactions;
}

async function removeAccount(accessToken, id) {
  await api("DELETE", accessToken, `accounts/${id}`);
  console.log(`[Teller] removed account with id: ${id}`);
}
