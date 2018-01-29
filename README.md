 ## Stellar Federation  

### The simplest and cleanest Docker image for running federation

Build and run:
```
docker-compose build
docker-compose up -d
```

Creates a folder 'stellar' in your home folder.  Everything is stored there, delete it to reset.

### SSL NOTE:
Start it up once and stop it, for SSL to work you need to copy a folder named 'tls' inside ~/stellar/federation with your server.crt and server.key

### Adding Accounts:

To add accounts look inside entry.sh for the line 'INSERT INTO people ...'
Add your accounts there

Pull requests welcome!

### Donations
If you like the code, a donation would be appreciated. Even a single XLM!

Click here for the [`donation page`](https://stellarkit.io/#/donate). Nano support!

```
XLM: GCYQSB3UQDSISB5LKAL2OEVLAYJNIR7LFVYDNKRMLWQKDCBX4PU3Z6JP
```
