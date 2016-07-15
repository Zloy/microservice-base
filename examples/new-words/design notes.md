# design notes

The whole solution consists of few parts:

* a browser plugin Translator
* a browser plugin Teacher
* API service


## plugin Translator

When a user double clicks on a word, the word goes to the plugin which gets the *word info* - translation, pronounciation and
examples of the word using and shows that info in a popup. It collects word info from Google translator and possibly other
online services, e.g. from Longman dictionary, Oxford dictionary, Urban dictionary.

When popup is shown to a user, the plugin passes the word info to the Teacher plugin.

So, the plugin has two main functions: it gets and shows a *word info* in a popup and passes the word info to Teacher plugin.


## plugin Teacher

When plugin starts, in case the plugin cannot find any word in the browser store it asks API service for the user words.

When a new word info is passed to that plugin it saves it to a browser store and makes AJAX request to API service to store
the new word for the user account.

That plugin provides a screen or few screens with translation challenges to the user. The user should translate collected words
from English or vice versa. When user feels confident about certain word he marks the word as learned. At that moment the plugin
makes API call to save that mark.

So, the plugin has two main functions: it maintains two copies of translated words list - one in a browser store and antoher in
API service, and provides a user with challenges that help him to remember collected words.

As long as user has an account in API service the plugin should have the options page on which the user enters his credentials
or creates a new account in API service.


## API service

It handles requests from Teacher plugin. All request data are in JSON form. Here `/w` stands for words.

    GET    /w - gets the full array of word info
    POST   /w/<a word> - adds the word info provided in the request body
    DELETE /w/<a word> - removes the word info as a mistake
    PUT    /w/<a word>/learned - removes the word info for learned word
