# configure MFA to  an  ec2-instance
## comfigure a bastion host
   -https://github.com/vivechanchanny/wordpress-serverlesss/tree/main/bastion#configure-bastion
## Install EPEL Repo on the EC2 instance
```
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```
##  Install Google Authenticator on the EC2 instance
```
sudo yum install google-authenticator.x86_64 -y
```
## Configure EC2 SSH to use Google Authentication module
   - Update the sshd PAM and install Google authenticator module
   ```
   sudo vi /etc/pam.d/sshd
   ```
   - Add the following to the bottom of the file to use Google Authenticator. If there are service accounts or users who should be able to log in without MFA, add nullok at the end of the following statement. This will mean that users who don’t run Google Authenticator initialization won’t be asked for a second authentication. 
   ```
   auth required pam_google_authenticator.so 
                          OR
   auth required pam_google_authenticator.so nullok
   ```
   - Comment out the password requirement as we want to use only the key-based authentication
   ```
   #auth       substack     password-auth 
   ```
   - Save the file.
## Make sshd daemon to prompt the user for the Verification Code.
   - Edit the file as root
   ```
   sudo vi /etc/ssh/sshd_config
   ```
   - Comment out the line which says ChallengeResponseAuthentication ‘no’ and uncomment the line which says ‘yes’.  
   ```
   ChallengeResponseAuthentication yes
   #ChallengeResponseAuthentication no
   ``` 
   - let sshd daemon know that it should ask the user for an SSH key and a verification code
   ```
   AuthenticationMethods publickey,keyboard-interactive
   ```
## Configure Google Authenticator
- Install Google Authenticator on the mobile
```
   https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_IN
                                        OR
                                        
   https://apps.apple.com/in/app/google-authenticator/id388497605                              
```   
-  Run Google Authenticator on EC2 and Get QR code
      - run the following command as the user of your choice in my case it is ec2-user
  ```
  google-authenticator
  ```
      - Scan the Shown QR code in your Google Authenticator App
## Complete the Google Authenticator Setup in EC2
```
[ec2-user@ip-172-31-83-181 ~]# google-authenticator

Do you want authentication tokens to be time-based (y/n) y

******* THERE WOULD BE A QR CODE DISPLAYED HERE ****
 

Your new secret key is: 2IAROUZWA6ZRSRRR89ZLYNZUC2A
Your verification code is 601376
Your emergency scratch codes are:
  85535499
  25397636
  98473698
  70322035
  60012461

Do you want me to update your "/root/.google_authenticator" file? (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, a new token is generated every 30 seconds by the mobile app.
In order to compensate for possible time-skew between the client and the server,
we allow an extra token before and after the current time. This allows for a
time skew of up to 30 seconds between authentication server and client. If you
experience problems with poor time synchronization, you can increase the window
from its default size of 3 permitted codes (one previous code, the current
code, the next code) to 17 permitted codes (the 8 previous codes, the current
code, and the 8 next codes). This will permit for a time skew of up to 4 minutes
between client and server.
Do you want to do so? (y/n) n

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```
## Restart SSH services  on the EC2 server
```
sudo service sshd restart
```
## SSH to validate the AWS MFA setup.
```
ssh -i ~/Downloads/mykeypair.pem ec2-user@3.95.13.122
```

    
