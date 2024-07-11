# Introduction

JWT is a standard way to pass trusted information between systems.
https://JWT.io has lots of good information and tools regarding JWTs.

In this exercise, we will be manually creating JWT, simulating a client
that acquires and send JWT to a server component.

# Question 1

Use the interactive tool on https://jwt.io to create a JWT with hmac
sha256 signature with a secret "wmdd4950" (payload doesn’t matter).  

Using `curl` on the command line, check that you have created this
correctly by sending this jwt with the 

```
Authorization: Bearer
```

header to https://learn.operatoroverload.com/~jmadar/lab7/q1.sh.
If you get a http status 200 code, you got it correct.  

Put your token in a file called `q1.txt`

# Question 2

Let's do some brute force hacking!

The URL `https://learn.operatoroverload.com/~jmadar/lab7/q2.sh`
would only return http status 200 if it is called with a valid token
(payload doesn't matter).  The token uses the hmac-sha256 algorithm
for its signature but you don’t know the secret.  However, you found
out that the programmer pick the secret from one of the first 150 common
passwords
(https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt) 

Write a bash script `q2.sh` to figure out the secret.

See the below terminal interaction.

```console
$ ./q2.sh 
The secret is ******
```


```console
$ HEADER='{"alg":"HS256","typ":"JWT"}'
$ PAYLOAD="{}"
$ B64_HEADER=$(echo -n "$HEADER" | base64 | tr '+' '-' | tr '/' '_' | tr -d '=')
$ B64_PAYLOAD=$(echo -n "$PAYLOAD" | base64 | tr '+' '-' | tr '/' '_' | tr -d '=')
$ SIGNATURE=$(echo -n "${B64_HEADER}.${B64_PAYLOAD}" \
>     | openssl dgst -sha256 -hmac "here_is_my_secret" -binary \
>     | base64 | tr '+' '-' | tr '/' '_' | tr -d '=')
$ JWT="${B64_HEADER}.${B64_PAYLOAD}.${SIGNATURE}"
$ curl -H "Authorization: Bearer $JWT" https://learn.operatoroverload.com/~jmadar/lab7/q2.sh 
Token has been tempered!
JWT Signature: 9d4jsGXa4QnZlAhi5pwp-c8jrGsvIt_2NBwhHIMpE3U
Verificaion Signature: 7tiyRKOwOsp5fLXrdY2HZ2gQtPl-J9NIw0wTX45umII
```

In the above, we create a JWT with an empty payload and sign with the phrase
"here_is_my_secret".  When this is sent to the
`https://learn.operatoroverload.com/~jmadar/lab7/q2.sh`, the return message
tells you that the phrase is incorrect.  Your job is to find the correct
secret phrase using a bash script.

HINT: You basically need to run a loop on the SIGNATURE line, each time with a
new password from the 150 common password file.

The following bash code takes the first 150 passwords and echo it to the terminal:

```bash
PASSWORDS=$(curl -s https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt | head -n 150)
for PASS in $PASSWORDS 
do   
  echo $PASS
done
```

Put your solution in a script file called `q2.sh`, make sure it's executable.

