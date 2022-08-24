




[![Massdriver][logo]][website]

# aws-msk-cluster

[![Release][release_shield]][release_url]
[![Contributors][contributors_shield]][contributors_url]
[![Forks][forks_shield]][forks_url]
[![Stargazers][stars_shield]][stars_url]
[![Issues][issues_shield]][issues_url]
[![MIT License][license_shield]][license_url]

<!--
##### STILL NEED TO GET SLACK WORKING ###
[!["Slack Community"](%s)][slack]
-->


Amazon Managed Streaming for Apache Kafka (MSK). Securely stream data with a fully managed, highly available Apache Kafka service.


---

## Design

For detailed information, check out our [Operator Guide](operator.mdx) for this bundle.

## Usage

Our bundles aren't intended to be used locally, outside of testing. Instead, our bundles are designed to be configured, connected, deployed and monitored in the [Massdriver][website] platform.

### What are Bundles?

Bundles are the basic building blocks of infrastructure, applications, and architectures in [Massdriver][website]. Read more [here](https://docs.massdriver.cloud/concepts/bundles).

## Bundle

### Params

Form input parameters for configuring a bundle for deployment.

<details>
<summary>View</summary>

<!-- PARAMS:START -->
## Properties

- **`brokers_per_zone`** *(number)*: Number of brokers per availability zone. Must be one of: `[1, 2, 3, 4]`. Default: `1`.
- **`instance_type`** *(string)*: Type of instance for brokers. Must be one of: `['kafka.t3.small', 'kafka.m5.large', 'kafka.m5.xlarge', 'kafka.m5.2xlarge', 'kafka.m5.4xlarge', 'kafka.m5.8xlarge', 'kafka.m5.12xlarge', 'kafka.m5.16xlarge', 'kafka.m5.24xlarge']`.
- **`kafka_version`** *(string)*: The version of Kafka to run. Must be one of: `['2.8.1', '2.8.0', '2.7.2', '2.7.0', '2.6.3', '2.6.2', '2.6.1', '2.6.0', '2.5.1', '2.4.1.1', '2.3.1', '2.2.1']`. Default: `2.6.2`.
- **`logging_method`** *(string)*: Method used to store kafka logs. Must be one of: `['cloudwatch', 's3']`. Default: `cloudwatch`.
- **`volume_size`** *(integer)*: EBS volume size for message storage in GiB (between 1 and 16384). Minimum: `1`. Maximum: `16384`.
## Examples

  ```json
  {
      "__name": "Staging",
      "brokers_per_zone": 1,
      "instance_type": "kafka.t3.small",
      "kafka_version": "2.6.2",
      "logging_method": "cloudwatch",
      "volume_size": 100
  }
  ```

  ```json
  {
      "__name": "Production",
      "brokers_per_zone": 1,
      "instance_type": "kafka.m5.2xlarge",
      "kafka_version": "2.6.2",
      "logging_method": "s3",
      "volume_size": 500
  }
  ```

<!-- PARAMS:END -->

</details>

### Connections

Connections from other bundles that this bundle depends on.

<details>
<summary>View</summary>

<!-- CONNECTIONS:START -->
## Properties

- **`aws_authentication`** *(object)*: . Cannot contain additional properties.
  - **`data`** *(object)*
    - **`arn`** *(string)*: Amazon Resource Name.

      Examples:
      ```json
      "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
      ```

      ```json
      "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
      ```

    - **`external_id`** *(string)*: An external ID is a piece of data that can be passed to the AssumeRole API of the Security Token Service (STS). You can then use the external ID in the condition element in a role's trust policy, allowing the role to be assumed only when a certain value is present in the external ID.
  - **`specs`** *(object)*
    - **`aws`** *(object)*: .
      - **`region`** *(string)*: AWS Region to provision in.

        Examples:
        ```json
        "us-west-2"
        ```

      - **`resource`** *(string)*
      - **`service`** *(string)*
      - **`zone`** *(string)*: AWS Availability Zone.

        Examples:
- **`vpc`** *(object)*: . Cannot contain additional properties.
  - **`data`** *(object)*
    - **`infrastructure`** *(object)*
      - **`arn`** *(string)*: Amazon Resource Name.

        Examples:
        ```json
        "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
        ```

        ```json
        "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
        ```

      - **`cidr`** *(string)*

        Examples:
        ```json
        "10.100.0.0/16"
        ```

        ```json
        "192.24.12.0/22"
        ```

      - **`internal_subnets`** *(array)*
        - **Items** *(object)*: AWS VCP Subnet.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

          - **`aws_zone`** *(string)*: AWS Availability Zone.

            Examples:
          - **`cidr`** *(string)*

            Examples:
            ```json
            "10.100.0.0/16"
            ```

            ```json
            "192.24.12.0/22"
            ```


          Examples:
      - **`private_subnets`** *(array)*
        - **Items** *(object)*: AWS VCP Subnet.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

          - **`aws_zone`** *(string)*: AWS Availability Zone.

            Examples:
          - **`cidr`** *(string)*

            Examples:
            ```json
            "10.100.0.0/16"
            ```

            ```json
            "192.24.12.0/22"
            ```


          Examples:
      - **`public_subnets`** *(array)*
        - **Items** *(object)*: AWS VCP Subnet.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

          - **`aws_zone`** *(string)*: AWS Availability Zone.

            Examples:
          - **`cidr`** *(string)*

            Examples:
            ```json
            "10.100.0.0/16"
            ```

            ```json
            "192.24.12.0/22"
            ```


          Examples:
  - **`specs`** *(object)*
    - **`aws`** *(object)*: .
      - **`region`** *(string)*: AWS Region to provision in.

        Examples:
        ```json
        "us-west-2"
        ```

      - **`resource`** *(string)*
      - **`service`** *(string)*
      - **`zone`** *(string)*: AWS Availability Zone.

        Examples:
<!-- CONNECTIONS:END -->

</details>

### Artifacts

Resources created by this bundle that can be connected to other bundles.

<details>
<summary>View</summary>

<!-- ARTIFACTS:START -->
## Properties

- **`authentication`** *(object)*: Highly scalable event bus managed by AWS. Cannot contain additional properties.
  - **`data`** *(object)*: Cannot contain additional properties.
    - **`authentication`** *(object)*: Zookeeper and bootstrap broker connection strings. Cannot contain additional properties.
      - **`brokers_connection_string`** *(string)*
      - **`zookeeper_connection_string`** *(string)*
    - **`infrastructure`**
      - **One of**
        - AWS Infrastructure ARN*object*: Minimal AWS Infrastructure Config. Cannot contain additional properties.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

    - **`security`**
      - **One of**
        - AWS Security information*object*: Informs downstream services of network and/or IAM policies. Cannot contain additional properties.
          - **`iam`** *(object)*: IAM Policies. Cannot contain additional properties.
            - **`^[a-z-/]+$`** *(object)*
              - **`policy_arn`** *(string)*: AWS IAM policy ARN.

                Examples:
                ```json
                "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
                ```

                ```json
                "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
                ```

          - **`network`** *(object)*: AWS security group rules to inform downstream services of ports to open for communication. Cannot contain additional properties.
            - **`^[a-z-]+$`** *(object)*
              - **`arn`** *(string)*: Amazon Resource Name.

                Examples:
                ```json
                "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
                ```

                ```json
                "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
                ```

              - **`port`** *(integer)*: Port number. Minimum: `0`. Maximum: `65535`.
              - **`protocol`** *(string)*: Must be one of: `['tcp', 'udp']`.
  - **`specs`** *(object)*
    - **`kafka`** *(object)*: Informs downstream bundles of Kafka specific data. Cannot contain additional properties.
      - **`version`** *(string)*: Currently deployed Kafka version.
<!-- ARTIFACTS:END -->

</details>

## Contributing

<!-- CONTRIBUTING:START -->

### Bug Reports & Feature Requests

Did we miss something? Please [submit an issue](https://github.com/massdriver-cloud/aws-msk-cluster/issues) to report any bugs or request additional features.

### Developing

**Note**: Massdriver bundles are intended to be tightly use-case scoped, intention-based, reusable pieces of IaC for use in the [Massdriver][website] platform. For this reason, major feature additions that broaden the scope of an existing bundle are likely to be rejected by the community.

Still want to get involved? First check out our [contribution guidelines](https://docs.massdriver.cloud/bundles/contributing).

### Fix or Fork

If your use-case isn't covered by this bundle, you can still get involved! Massdriver is designed to be an extensible platform. Fork this bundle, or [create your own bundle from scratch](https://docs.massdriver.cloud/bundles/development)!

<!-- CONTRIBUTING:END -->

## Connect

<!-- CONNECT:START -->

Questions? Concerns? Adulations? We'd love to hear from you!

Please connect with us!

[![Email][email_shield]][email_url]
[![GitHub][github_shield]][github_url]
[![LinkedIn][linkedin_shield]][linkedin_url]
[![Twitter][twitter_shield]][twitter_url]
[![YouTube][youtube_shield]][youtube_url]
[![Reddit][reddit_shield]][reddit_url]

<!-- markdownlint-disable -->

[logo]: https://raw.githubusercontent.com/massdriver-cloud/docs/main/static/img/logo-with-logotype-horizontal-400x110.svg
[docs]: https://docs.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=docs
[website]: https://www.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=website
[github]: https://github.com/massdriver-cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=github
[slack]: https://massdriverworkspace.slack.com/?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=slack
[linkedin]: https://www.linkedin.com/company/massdriver/?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=linkedin



[contributors_shield]: https://img.shields.io/github/contributors/massdriver-cloud/aws-msk-cluster.svg?style=for-the-badge
[contributors_url]: https://github.com/massdriver-cloud/aws-msk-cluster/graphs/contributors
[forks_shield]: https://img.shields.io/github/forks/massdriver-cloud/aws-msk-cluster.svg?style=for-the-badge
[forks_url]: https://github.com/massdriver-cloud/aws-msk-cluster/network/members
[stars_shield]: https://img.shields.io/github/stars/massdriver-cloud/aws-msk-cluster.svg?style=for-the-badge
[stars_url]: https://github.com/massdriver-cloud/aws-msk-cluster/stargazers
[issues_shield]: https://img.shields.io/github/issues/massdriver-cloud/aws-msk-cluster.svg?style=for-the-badge
[issues_url]: https://github.com/massdriver-cloud/aws-msk-cluster/issues
[release_url]: https://github.com/massdriver-cloud/aws-msk-cluster/releases/latest
[release_shield]: https://img.shields.io/github/release/massdriver-cloud/aws-msk-cluster.svg?style=for-the-badge
[license_shield]: https://img.shields.io/github/license/massdriver-cloud/aws-msk-cluster.svg?style=for-the-badge
[license_url]: https://github.com/massdriver-cloud/aws-msk-cluster/blob/main/LICENSE


[email_url]: mailto:support@massdriver.cloud
[email_shield]: https://img.shields.io/badge/email-Massdriver-black.svg?style=for-the-badge&logo=mail.ru&color=000000
[github_url]: mailto:support@massdriver.cloud
[github_shield]: https://img.shields.io/badge/follow-Github-black.svg?style=for-the-badge&logo=github&color=181717
[linkedin_url]: https://linkedin.com/in/massdriver-cloud
[linkedin_shield]: https://img.shields.io/badge/follow-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&color=0A66C2
[twitter_url]: https://twitter.com/massdriver?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=twitter
[twitter_shield]: https://img.shields.io/badge/follow-Twitter-black.svg?style=for-the-badge&logo=twitter&color=1DA1F2
[discourse_url]: https://community.massdriver.cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-msk-cluster&utm_content=discourse
[discourse_shield]: https://img.shields.io/badge/join-Discourse-black.svg?style=for-the-badge&logo=discourse&color=000000
[youtube_url]: https://www.youtube.com/channel/UCfj8P7MJcdlem2DJpvymtaQ
[youtube_shield]: https://img.shields.io/badge/subscribe-Youtube-black.svg?style=for-the-badge&logo=youtube&color=FF0000
[reddit_url]: https://www.reddit.com/r/massdriver
[reddit_shield]: https://img.shields.io/badge/subscribe-Reddit-black.svg?style=for-the-badge&logo=reddit&color=FF4500

<!-- markdownlint-restore -->

<!-- CONNECT:END -->
