---
layout: post
title: "SpringSecurity Impersonate Users Custom Roles"
date: 2015-04-13 00:20:15 +0200
comments: true
published: false
categories:
- Groovy
- Grails
- SpringSecurity
---
The Grails SpringSecurity plugin has the ability to allow user impersonation which is a really great tool for support. But many times it makes sense to allow your support user to see different things than a user. We use a special role to achieve this behavior we can also have different roles for tiers of support.

By default even impersonation or user switching is turned off in the plugin by default. You can easily turn it on with a config flag:

```
grails.plugin.springsecurity.useSwitchUserFilter = true
```

Spring Security by default will add a new role of [ROLE_PREVIOUS_ADMINISTRATOR](http://docs.spring.io/autorepo/docs/spring-security/3.2.1.RELEASE/apidocs/constant-values.html#org.springframework.security.web.authentication.switchuser.SwitchUserFilter.ROLE_PREVIOUS_ADMINISTRATOR) for the user while impersonating the other user. This will work in most cases but for us it was hard to reason about since we had an idea of admin which was separate from our support team who would mostly be using this tool.

So for our use we used the 
