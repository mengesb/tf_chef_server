v0.0.1 2016-02-04
-------------------
- Implement version in `CHANGELOG.md`
- Create `CHANGELOG.md`
- Finalize module
- Updates to `outputs.tf`, added more information
- Updates to `variables.tf`, adding descriptions

Thu Feb 4 21:18:09 2016 -0800 [33mb9e2aa0]
-------------------
- Fixed old chef exec command hanging around
- Fixed IPTables issues; flush then set complete rule set

Thu Feb 4 20:19:39 2016 -0800 [33m14b29b9]
-------------------
- Fixing references to aws_instance provider items

Thu Feb 4 20:15:00 2016 -0800 [33m5bc32bc]
-------------------
- removed cookbooks directory file sync
- execute chef server creation directly at server
- create first user
- create first org
- associate user to org
- download user pem
- download org validator pem

Thu Feb 4 11:00:44 2016 -0800 [33m954a88d]
-------------------
- fix bulleted list

Thu Feb 4 10:59:36 2016 -0800 [33ma4c360c]
-------------------
- Supported OSes
- more assumptions

Thu Feb 4 10:52:53 2016 -0800 [33m2879244]
-------------------
- Delete email linking

Thu Feb 4 10:52:08 2016 -0800 [33me856561]
-------------------
- Correcting e-mail link for Brian Menges

Thu Feb 4 10:48:01 2016 -0800 [33m8b5553f]
-------------------
- Correcting linking syntax for users

Thu Feb 4 10:44:43 2016 -0800 [33m1077c11]
-------------------
- Correcting linking syntax

Thu Feb 4 10:40:56 2016 -0800 [33me261f30]
-------------------
- Updating README.md
- More explanation about how to use this module

Wed Feb 3 14:22:21 2016 -0800 [33mb66e077]
-------------------
- moved connection outside of the provisioners per @afiune recommendation
- Added TODO to get rid of the provisioner file hack
- creative addition of git package supporting CentOS and Ubuntu

Wed Feb 3 12:09:03 2016 -0800 [33m3015e80]
-------------------
- SPELLING!

Wed Feb 3 12:06:28 2016 -0800 [33m4a9a5eb]
-------------------
- Fixing org to chef_org

Wed Feb 3 11:40:28 2016 -0800 [33m2440c7c]
-------------------
- Mixed up region and vpc

Wed Feb 3 11:35:46 2016 -0800 [33m5475d18]
-------------------
- Removing AMI magic
- Getting too complex, simplifying things

Tue Feb 2 22:06:18 2016 -0800 [33m3a1a2b0]
-------------------
- Fixed ami reference, using lookup now

Tue Feb 2 21:45:46 2016 -0800 [33m3f76ee1]
-------------------
- Initial commit

Tue Feb 2 17:44:13 2016 -0800 [33mc5e5f07]
-------------------
- Create repo
