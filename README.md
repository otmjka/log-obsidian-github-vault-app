# Log Obsidian Github vauld app

[b-log app link](http://b-log-app-load-balancer-1189058679.eu-north-1.elb.amazonaws.com/)

Idea is write notes in the obsidian.
In obsidian vault init github repository.
And dummy Next.js app that read file names from a repo.
and show items by mdx component.

https://api.github.com/repos/otmjka/log-content/git/trees/main?recursive=1

## start by docker

https://nextjs.org/docs/app/building-your-application/deploying#docker-image

```
docker build -t b-log .
docker build --platform=linux/amd64 -t b-log .
docker run -e PORT=80 -p 80:80 b-log:latest

```
