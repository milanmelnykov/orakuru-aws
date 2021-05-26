# Terraform code for provisioning Orakuru infrastructure on AWS. Maintain it in a code!

There are 3 modules atm and they are covering 3 things:
 * Network
 * Security
 * EC2 (main node + monitoring node)

EC2 module contains `user_data` scripts to deploy *bsc node* on main server and *grafana+prometheus* on monitoring server.

## Step by step guide:
 * Install latest version of Terraform . 
 * Set your AWS credentials so Terraform can interact with your AWS acount.
    ```sh
     export AWS_ACCESS_KEY_ID=<your_access_key>
     export AWS_SECRET_ACCESS_KEY=<your_secret_key>
     export AWS_DEFAULT_REGION=<desired_region>
    ```
 *  Change variables at vars.tf if needed. 
 *  Check plan.
     ```sh
    terraform plan
    ```
 * If everything in that plan looks fine you can run `apply` command.
    ```sh
    terraform apply
    ```
 ## Post actions
 * Deploy Orakuru node on main server
   - Via Docker : https://orakuru.gitbook.io/crystal-ball/running-the-node/installing-orakuru-node
   - Building from sources:
     - Manually : https://orakuru.gitbook.io/crystal-ball/advanced-guides/building-orakuru-node-from-source 
     - With Ansible by [cryptobuddha](https://github.com/0x-cryptobuddha) : https://github.com/0x-cryptobuddha/orakuru-node-playbook
 * Monitoring final configuration
   - Make sure `9000` port is open on main server and `3000` on monitoring node
   - Go to http://<monitoring_instance_pub_ip>:3000 and configure your profile. Default user & pass is `admin`
   - Add Prometheus data source - `http://localhost:9090`
   - Import custom dashboard by [steve-pro](https://github.com/stevepro-lab) : https://github.com/stevepro-lab/orakuru-node-docker-custom/blob/master/grafana/grafana.json

## That's it. Enjoy :)
