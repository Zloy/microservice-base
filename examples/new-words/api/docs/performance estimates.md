# Performance estimates

**U** = 100_000_000 users

**WP** = 1024 - average bytes per one word payload.


### POST /w/:word Add a word

Each user adds about **uwpw** = 50 words per week

So it goes to **wps** = U * uwpw / 7 / 24 / 3_600 = 8_267 words/sec

Taking into account wps is a mean value, lets set wps maximum to 10 times of wps mean, so **wps_max** = 10 * wps for peak loads

Also coming words should not go directly to DB, they could be buffered in a queue

Let also assume the peak could not last long. Let set its duration to 1 hour. That means that the application should sustain 1 hour load with wps = 10 * wps = 82_670 words/sec = 297_612_000 words/hour.

The data flows with the rate **wflow** = wps * WP = 8_267 * 1 Kb = 8 Mb [[/sec]] and maximum flow is **wflow_max** = 80 Mb/s


### PUT /w/:word/learned Learn a word

Assume users learn all words, they added for a week in a week. That means users mark words as learned with the same rate they add them.

The endpoint should maintain wps rate with the same peak value **lwps** = wps . Queueing applies, but the situation is better because there is no payload in such requests.


### GET /w Get all words

Users need their words in case they cleared browser storage, or they started using Teacher plugin in a new browser/machine.

Assume it occurs on average at most after 1000 new word added. So the rate of getting all words is 1000 times less than word addition rate awps = wps / 1000 = 827 rps. Queueing is not applicable. The peak factor is the same 10. Big payload.


### DELETE /w/:word Delete mistakenly added word

Users make mistakes klicking on wrong words, which either they already know, or they just want to copy for whatever reason. Users want to delete such words. Assume they click one wrong word every 20 clicks on right words. Thus, wrong word rate is **wwps** = wps / 20 = 413 wps. Queueing is applicable, also no payload.
