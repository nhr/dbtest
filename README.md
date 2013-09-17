# DB Test Rig

This is a very simple setup for a DB test in
[OpenShift](http://www.openshift.com).

1. Create a new Ruby 1.9 app
2. Add a mysql DB to it
3. Clone this repo into your local app code:
    1. `cd <local repo dir>`
    2. `git remote add upstream -m master
       git://github.com/nhr/dbtest.git`
    3. `git pull -s recursive -X theirs upstream master`
4. Push the repo upstream: `git push`
5. SSH into the app
6. Run `mysql @${OPENSHIFT_REPO_DIR}/sql/setup.sql`
7. Run `$OPENSHIFT_REPO_DIR/populate.rb`

In about two hours, you will have two million rows of semi-random
data.
