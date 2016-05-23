Contributing to tf_chef_server
==============================

All contributors are welcome to submit patches but please keep the following in mind:

- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Prerequisites](#prerequisites)

Please also keep in mind:

- Be patient as not all items will be tested or reviewed immediately by the core team.
- Be receptive and responsive to feedback about your additions or changes. The myself and/or other community members may make suggestions or ask questions about your change. This is part of the review process, and helps everyone to understand what is happening, why it is happening, and potentially optimizes your code.
- Be understanding

If you're looking to contribute but aren't sure where to start, check out the open issues.

Will Not Merge
--------------
This details Pull Requests that we will **not** be merged.

- New features without accompanying tests or proof of operation
- New features without accompanying usage documentation

Coding Standards
----------------
The submitted code should be compatible with the following standards

- 2-space indentation style
- First curl brace on the same line as the method
- Closing curl brace on its own aligned newline
- Variable and value assignment does not need to be aligned with assignment operator
- Where possible, avoid HEREDOC in favor of script or templates

Testing
-------
Please indicate the results of your tests in a comment along with the pull request. Supplying tests and the method used to run/validate the changes are highly encouraged.

Prerequisites
-------------
Familiarize yourself with Terraform and be well versed in its interpolations.

- [Terraform](https://www.terraform.io/docs/index.html)

Familiarize yourself with Chef and the operation of the chef-server cookbook

- [chef-server](https://github.com/chef-cookbooks/chef-server) cookbook

Process
-------
1. Fork the git repository from GitHub:

3. Create a branch for your changes:

        $ git checkout -b my_bug_fix

4. Make any changes

5. Write tests to support those changes.

6. Run the tests:

7. Assuming the tests pass, open a Pull Request on GitHub and add results


Do's and Don't's
----------------
- **Do** include tests for your contribution
- **Do** request feedback via GitHub issues or other contact
- **Do NOT** break existing behavior (unless intentional)
- **Do NOT** modify the [CHANGELOG](CHANGELOG)
