module.exports = {
  calculateSpentMoney,
  getTopCategories,
  getAllTransactions,
  calculateSpentMoney,
};

const transactionsExcludeTypes = ["withdrawal", "credit", "deposit"];

function shouldExclude(transaction) {
  if (
    transactionsExcludeTypes.contains(transaction.type) ||
    transaction.description.toLowerCase().contains("withdrawal")
  ) {
    return true;
  }
  return false;
}

function calculateSpentMoney(transactions) {
  var spentMoney = 0;
  for (var i in transactions) {
    const transaction = transactions[i];

    if (shouldExclude(transaction)) {
      continue;
    }

    var amount = parseFloat(transaction.amount);
    if (amount == null || amount > 0) continue;
    spentMoney -= amount;
  }
  return spentMoney;
}

function getTopCategories(transactions) {
  var topCategories = new Map();
  for (var i in transactions) {
    const transaction = transactions[i];

    if (shouldExclude(transaction)) {
      continue;
    }

    var amount = parseFloat(transaction.amount);
    if (amount == null || amount > 0) continue;
    amount = Math.abs(amount);

    var category = transaction.details.category;
    category = category[0].toUpperCase() + category.slice(1);

    if (topCategories.has(category)) {
      topCategories[category] = topCategories[category] + amount;
    } else {
      topCategories[category] = amount;
    }
  }

  var arr = new Array();

  for (const [key, value] of Object.entries(topCategories)) {
    arr.push(new ReportInfo(key, value));
  }
  arr.sort((a, b) => (b.amount > a.amount ? 1 : a.amount > b.amount ? -1 : 0));

  return arr;
}

function getAllTransactions(transactions) {
  var arr = new Array();
  for (var i in transactions) {
    const transaction = transactions[i];

    if (shouldExclude(transaction)) {
      continue;
    }

    var amount = parseFloat(transaction.amount);
    if (amount == null || amount > 0) continue;
    amount = Math.abs(amount);
    var description = transaction.description;
    arr.push(new ReportInfo(description, amount));
  }
  // arr.sort((a, b) => (b.amount > a.amount ? 1 : a.amount > b.amount ? -1 : 0));

  return arr;
}

class ReportInfo {
  name = String;
  amount = Number;

  constructor(name, ammount) {
    this.name = name;
    this.amount = ammount;
  }
}
