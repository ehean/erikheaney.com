---
title: "How I Created My Personal Website (WIP)"
date: 2023-11-18
author: Erik Heaney
draft: true
---
{{< toc >}}
## Summary
Here is the total cost of maintaining this website:
* Hosting: $5/month on Akamai's Linode
* Domain Name: $20/year on Squarespace
* Total cost: $80/year

Here is a list of free tools I use:
* Front-end framework: Hugo
* Reverse Proxy: nginx
* Version Control: GitHub
* Firewall: ufw
* SSL certificate maintainenance: certbot
* Web Analytics: plausible

I designed this site to be cheap, simple, and flexible. I can push change to my public site in a second. No complicated infrastructure to build or maintain, no CI/CD pipelines, no GUI or platform to learn to use, only for the company to change and I have to relearn. If for whatever reason Linode gets more expensive, I can run this site on AWS, Azure, GCP, self-host, really anywhere. I can add features as I wish, no need to upgrade plans.

## Why Create Your Own Website?
In short, here are 3 very good reasons to create your own personal website:
* Price
* Control
* Fun

### Price
Here is the price breakdown of 4 of the biggest blogging tools (as of 2023): 
{{< table "table table-dark table-striped table-bordered" >}}
| | WordPress | Wix | Squarespace | Weebly |
|-|---------|--------|-|-|
| Free Plan | Yes |Yes |No |Yes|
|Monthly Price |$4 to $59 |$16 to $45 |$16 to $65 |$6 to $26 |
{{</table>}}

While many of the above platforms offer free and cheap plans, the cheaper the plan the more limited the product. As your site grows, you may want to add SEO or allow customers to pay you via a point of sale (PoS). To do this, you will need to upgrade to a more expensive plan. 

### Control
As mentioned above, features will always be behind a paywall. But even if you pay for the most expensive plan, you need to build the site within their platform. Essentially, you need to become a WordPress specialist to build a site with WordPress's platform. Personally, I found WordPress's platform hard to use. I bought their cheapest plan, which is $48/year (they don't allow for monthly billing, only yearly) because I thought I could build a blog quickly. I was wrong. I found their GUI confusing and frustrating. Others may find WordPress easy, but I did not. 

On top of that, you will always be limited. You are on their platform, and are confined to the tools within the sandbox they provide you. You may be okay with that, but it is a trade-off to consider.

### Fun
It's more fun to build your own site! I felt a great sense of accomplishment when I got my website up and running, and I continue to feel that sense of accomplishment whenever I add something new. It's a great way to learn basic front-end software skills. As someone who works totally on backend infrastructure, I find this work to be refreshing. It's great to see something I can show friends and family that has my name on it and I can say I built and own. 

## Steps to building your own site
### Hosting
I chose Linode (which is now owned by Akamai) for its simplicty and price. Create an account, add your billing info, and you can spin up a very reliable and performant linux server with a public IP in a few seconds for $5/month. I don't need all the features and layers that AWS, GCP, or Azure provides. If you are building something more complex, then by all means use those platforms. But sometimes simpler is better. 

### Domain Name
I originally bought the domain name off of Google, but they no register domain names and point you to Squarespace. It used to be $12 a year on Google, and Squarespace now charges $20. If there's a better option, let me know. But it's super cool to have your name be your domain name. If you work in IT, it let's your website serve as a portfolio.

### Web Framework
There are all sorts of frontend frameworks and languages now - Angular, Ruby on Rails, PHP, etc. I am not a full-stack or frontend developer, so I can't tell you the pros and cons of each one. That's why I went with Hugo. Again, simplicity was the main motivator - it allowed me to build a blogging wite with as little frontend experience as possible while still giving me the control and flexibility I wanted. It's a static website generator, so instead of layers of javascript that builds the site with each client request, it simply builds the site when I update the content. I write a new blog post, I run hugo -D, and that's it. Also, since it's a static website, that means my website is very fast. And while it's not the most popular web framework, it's popular enough that you can find many themes that more experienced frontend developers have created on GitHub. I use this hugo-coder theme, a simple blogging theme created by luizdepra. 

### Firewall


### Reverse Proxy


### Managing SSL Certificates


### Web Analytics


### Startup Script
