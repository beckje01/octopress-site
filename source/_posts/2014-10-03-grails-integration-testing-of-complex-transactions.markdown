---
layout: post
title: "Grails Integration Testing of Complex Transactions"
date: 2014-10-03 09:29:53 -0500
comments: true
published: false
categories:
 - Groovy
 - Grails
---

Integration testing complex transactions in grails can be tricky due to the default behavior of wrapping integration tests in transactions and rolling them back when complete.

The simple solution is to simply turn off transactions for integration tests, that solution will work but tends to lead to data pollution in downstream tests. Burt Beckwith has a solution in his post [An Alternative Approach for Grails Integration Tests](http://burtbeckwith.com/blog/?p=82). Using this solution we can rebuild the database for each test.

In general most of the time you can use the default transactional testing behavior, therefore we want to only use this method some of the time. To active this effect we will modify Burt's original solution slightly.

 * Rebuild the database _after_ each test
 * Depend on the configured data source
 * Update to Spock

## Solution

Show spec code here 

## When to Use

Show custom propagation
