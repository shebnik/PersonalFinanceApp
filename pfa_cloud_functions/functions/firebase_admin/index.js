const { initializeApp } = require("firebase-admin/app");
initializeApp();

const functions = require("firebase-functions");

const { getFirestore, Timestamp } = require("firebase-admin/firestore");

const db = getFirestore();
const settings = { timestampsInSnapshots: true };
db.settings(settings);

const getUser = (userId) => {
  return db.collection("users").doc(userId).get();
};
const getMentor = (userId) => {
  return db.collection("mentors").doc(userId).get();
};
const getPreferences = (userId) => {
  return db.collection("preferences").doc(userId).get();
};

module.exports = {
  functions,
  db,
  Timestamp,
  getUser,
  getMentor,
  getPreferences,
};
