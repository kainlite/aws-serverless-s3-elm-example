### Example repo

Basically it's a super simple elm app, hosted in an AWS S3 bucket (Static website hosting),
It has a form that sends json data to an AWS Api Gateway and then with lambda sends the email using AWS SES.

To spin up the dev server:
```
elm-live src/App.elm --output=js/app.js
```

You can see the example code for go and node below:

https://github.com/kainlite/aws-serverless-go-ses-example

https://github.com/kainlite/aws-serverless-nodejs-ses-example
