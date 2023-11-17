const sgMail = require("@sendgrid/mail");
const moment = require("moment");

const { functions, getPreferences } = require("../firebase_admin/index");
const { db, getUser, getMentor } = require("../firebase_admin");
const {
  getAllTransactions,
  getTopCategories,
  calculateSpentMoney,
} = require("./transaction_service");

const emailFrom = {
  email: functions.config().emails.from,
  name: "PFA",
};
const emailReplyTo = functions.config().emails.replyto;
const SENDGRID_KEY = functions.config().sendgrid.key;
sgMail.setApiKey(SENDGRID_KEY);
sgMail.setSubstitutionWrappers("{{", "}}");

module.exports.sendEmailOnMentorUpdated = functions.firestore
  .document("mentors/{docId}")
  .onWrite(async (change, context) => {
    const mentor = change.after.data();
    const user = (await getUser(mentor.userId)).data();
    try {
      const msg = {
        to: mentor.mentorEmail,
        from: emailFrom,
        replyTo: emailReplyTo,
        templateId: "d-9182299eb8204bbb83f42b891d149c69",
        dynamicTemplateData: {
          userName: user.name,
          mentorName: mentor.mentorName,
        },
      };
      console.log("[sendEmailOnMentorUpdated] email: ", msg);

      await sgMail.send(msg);
      return true;
    } catch (error) {
      console.log(`[sendEmailOnMentorUpdated-ERROR]: ${error}`);
      if (error.response) {
        console.error(error.response.body);
      }
      return false;
    }
  });

module.exports.sendEmailDailyBudgetUpdated = functions.firestore
  .document("preferences/{docId}")
  .onUpdate(async (change, context) => {
    const preferencesBefore = change.before.data();
    const preferencesAfter = change.after.data();

    if (preferencesBefore.dailyBudget == preferencesAfter.dailyBudget) return;

    const userId = preferencesAfter.userId;

    const user = (await getUser(userId)).data();
    const mentor = (await getMentor(userId)).data();
    try {
      const msg = {
        to: mentor.mentorEmail,
        from: emailFrom,
        replyTo: emailReplyTo,
        templateId: "d-fd6ebc1157e84199a268c011d6a6ebe2",
        dynamicTemplateData: {
          userName: user.name,
          mentorName: mentor.mentorName,
          oldDailyBudget: preferencesBefore.dailyBudget,
          newDailyBudget: preferencesAfter.dailyBudget,
        },
      };
      console.log("[sendEmailDailyBudgetUpdated] email: ", msg);

      await sgMail.send(msg);
      return true;
    } catch (error) {
      console.log(`[sendEmailDailyBudgetUpdated-ERROR]: ${error}`);
      if (error.response) {
        console.error(error.response.body);
      }
      return false;
    }
  });

module.exports.sendEmailDailyReport = async function (
  user,
  transactions,
  date
) {
  const mentor = (await getMentor(user.userId)).data();
  const preferences = (await getPreferences(user.userId)).data();

  const dailyBudget = preferences.dailyBudget;
  const totalSpent = calculateSpentMoney(transactions);
  const overspent = totalSpent - dailyBudget;

  try {
    const msg = {
      to: mentor.mentorEmail,
      from: emailFrom,
      replyTo: emailReplyTo,
      templateId: "d-13da189af5884889b5b3d441e98e27e4",
      dynamicTemplateData: {
        mentorName: mentor.mentorName,
        userName: user.name,
        date: moment(new Date(date)).format("DD MMMM YYYY"),
        budgetStatus: overspent <= 0 ? "No overspending" : "Overspent",
        dailyBudget: formatAmount(dailyBudget),
        totalSpent: formatAmount(totalSpent),
        overspent: formatAmount(overspent),
        topCategories: getTopCategories(transactions),
        allTransactions: getAllTransactions(transactions),
      },
    };
    console.log("[sendEmailDailyReport] email: ", msg);

    await sgMail.send(msg);
    return true;
  } catch (error) {
    console.log(`[sendEmailDailyReport-ERROR]: ${error}`);
    if (error.response) {
      console.error(error.response.body);
    }
    return false;
  }
};

function formatAmount(num) {
  return "$" + (Math.round(num * 100) / 100).toFixed(2);
}
