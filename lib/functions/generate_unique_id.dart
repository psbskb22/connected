// Fancy ID generator that creates 20-character string identifiers with the following properties:
//  1. They're based on timestamp so that they sort *after* any existing ids.
//  2. They contain 72-bits of random data after the timestamp so that IDs won't collide with other clients' IDs.
//  3. They sort *lexicographically* (so the timestamp is converted to characters that will sort properly).
//  4. They're monotonically increasing.  Even if you generate more than one in the same timestamp, the
//     latter ones will sort after the former ones.  We do this by using the previous random bits
//     but "incrementing" them by 1 (only in the case of a timestamp collision).

import 'dart:math';

String generateUniqueID(int length) {
  if (length < 20) {
    print('minimum length is: 20');
    length = 20;
  }
  // Modeled after base64 web-safe chars, but ordered by ASCII.
  var pushChars =
      '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';

  // Timestamp of last push, used to prevent local collisions if you push twice in one ms.
  var lastPushTime = 0;

  // We generate 72-bits of randomness which get turned into 12 characters and appended to the
  // timestamp to prevent collisions with other clients.  We store the last characters we
  // generated because in the event of a collision, we'll use those same characters except
  // "incremented" by one.
  var lastRandChars = [];

  var now = DateTime.now().millisecondsSinceEpoch;
  var duplicateTime = (now == lastPushTime);
  lastPushTime = now;

  var timeStampChars = [];
  for (var i = 7; i >= 0; i--) {
    int divider = now % 64;
    if (divider == 0) divider = 1;
    timeStampChars.add(pushChars[divider]);
    // NOTE: Can't use << here because javascript will convert to int and lose the upper bits.
    now = (now / 64).round();
  }
  if (now != 0) print('We should have converted the entire timestamp');

  var id = timeStampChars.join('');
  if (!duplicateTime) {
    for (var i = 0; i < length - 8; i++) {
      Random random = new Random();
      lastRandChars.add((random.nextInt(64)).round());
    }
  } else {
    // If the timestamp hasn't changed since last push, use the same random number, except incremented by 1.
    int i = length - 7;
    for (i = length - 7; i >= 0 && lastRandChars[i] == 63; i--) {
      lastRandChars[i] = 0;
    }
    lastRandChars[i]++;
  }
  for (var i = 0; i < length - 8; i++) {
    id += pushChars[(lastRandChars[i])];
  }

  return id;
}
