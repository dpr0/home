// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "jquery"
import "@nathanvda/cocoon"
import "firebase"
import "firebaseui-ru"
import 'bootstrap'
import './stylesheets/application'
import firebase from 'firebase/app';
import Rails from "@rails/ujs"
// import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
// ActiveStorage.start()

document.addEventListener("turbolinks:load", () => {
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover()
});

var config = {
    apiKey: "AIzaSyAN5ln4_DNOGYo6Py3qE0TdyLrAv18bnws",
    authDomain: "home-10a6a.firebaseapp.com",
    databaseURL: "https://home-10a6a.firebaseio.com",
    projectId: "home-10a6a",
    storageBucket: "home-10a6a.appspot.com",
    messagingSenderId: "613014646899",
    appId: "1:613014646899:web:6d53f60c9f72c02b1e7a06"
};
firebase.initializeApp(config);
firebase.analytics();

var ui = new firebaseui.auth.AuthUI(firebase.auth());
ui.start('#firebaseui-auth-container', {
    signInOptions: [
        firebase.auth.GoogleAuthProvider.PROVIDER_ID,
        {provider: firebase.auth.PhoneAuthProvider.PROVIDER_ID, defaultCountry: 'ru'},
        firebase.auth.EmailAuthProvider.PROVIDER_ID,
        firebase.auth.GithubAuthProvider.PROVIDER_ID
    ],
    callbacks: {
        signInSuccessWithAuthResult: (currentUser) => {
            $.post('/users/auth/firebase/callback', {
                    authenticity_token: $('meta[name="csrf-token"]').attr("content"),
                    user: {
                        provider: currentUser.additionalUserInfo.providerId,
                        uid:      currentUser.user.uid,
                        email:    currentUser.user.email,
                        name:     currentUser.user.displayName,
                        phone:    currentUser.user.phoneNumber
                    }
                },
                () => window.location.reload()
            );
            return false;
        }
    },
    credentialHelper: firebaseui.auth.CredentialHelper.GOOGLE_YOLO
});
