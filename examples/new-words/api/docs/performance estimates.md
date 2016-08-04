# Performance estimates

**U** = 100_000_000 users

**WP** = 1024 - average bytes per one word payload.

## Stories

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


### GET /w Get all not learned words

Users need their words in case they cleared browser storage, or they started using Teacher plugin in a new browser/machine.

Assume it occurs on average at most after 1000 new word added. So the rate of getting all words is 1000 times less than word addition rate awps = wps / 1000 = 827 rps. Queueing is not applicable. The peak factor is the same 10.
Assume average user holds about 50 words to learn. Thus mean payload would be 50 * 1Kb = 50 Kb rep request, or 827 * 50 = 41 Mb/s


### DELETE /w/:word Delete mistakenly added word

Users make mistakes klicking on wrong words, which either they already know, or they just want to copy for whatever reason. Users want to delete such words. Assume they click one wrong word every 20 clicks on right words. Thus, wrong word rate is **wwps** = wps / 20 = 413 wps. Queueing is applicable, also no payload.

## Table

| endpoint | rps mean | rps max | payload mean Mb/s | payload max Mb/s | queueing |
|----------|----------|---------|-------------------|------------------|----------|
|`POST /w/:word`|8_267|82_670|8|80|yes|
|`PUT /w/:word/learned`|8_267|82_670|0|0|yes|
|`GET /w`|827|8_267|42|420|no|
|`DELETE /w/:word`|413|4130|0|0|yes|

Instead of synchronous `GET /w` I might introduce async endpoint:

* `POST /j/w/learned` to create a search job for getting all learned words which returns a :job_id to poll it later on
* `GET /j/:job_id` to poll the search job result

That redesign allows to use background workers to perform all work leaving API the role of a dumb http connector.

Dividing connector and data processing functionality between respectively API and workers simplifies complex data storage implementation including dynamic sharding, putting non accessing data to separate DBs and servers, etc.

Assuming there would be 2 polls on average for one job posted:

| endpoint | rps mean | rps max | payload mean Mb/s | payload max Mb/s | queueing |
|----------|----------|---------|-------------------|------------------|----------|
|`POST /j/w/learned` |    827|    8_267| 0|  0|yes|
|`GET /j/:job_id`    |2 * 827|2 * 8_267|42|420| no|
