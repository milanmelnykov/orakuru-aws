## Terraform code for provisioning orakuru infrastructure on AWS. Maintain your inftrsusctrucre in a code!

There are 3 modules atm and they are covering 3 things:
 - Network
 - Security
 - EC2

There is also an user_data script to setup bsc node on ec2 instance.
# Step by step guide:
 - Install latest Terraform version. 
 - Set your AWS credentials so Terraform can interact with your AWS acount.
    ```sh
     export AWS_ACCESS_KEY_ID=<your_access_key>
     export AWS_SECRET_ACCESS_KEY=<your_secret_key>
     export AWS_DEFAULT_REGION=<desired_region>
    ```
 -  Change variables at vars.tf if needed. 
 -  Check if everything works as expected.
     ```sh
    terraform plan
    ```
 - If everything worked fine in the last step, then run apply command.
    ```sh
    terraform apply
    ```
    
    ## Enjoy :)
