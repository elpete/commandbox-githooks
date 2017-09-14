/**
* Set up CommandBox to handle git hooks for this project.
*
* This command sets up a script that delegates all git hooks to CommandBox.
* The git hooks available are:
* + applypatch-msg
* + pre-applypatch
* + post-applypatch
* + pre-commit
* + prepare-commit-msg
* + commit-msg
* + post-commit
* + pre-rebase
* + post-checkout
* + post-merge
* + pre-receive
* + update
* + post-receive
* + post-update
* + pre-auto-gc
* + post-rewrite
* + pre-push
*
* The commands to be run are set up in your `box.json`. They are contained in a `githooks` key.
* Each git hook is defined by specifing the camel-cased version of the git hook.
* Either one command or an array of commands can be specified.  All commands are ran inside CommandBox.
*
* {code:json}
* {
*   "githooks": {
*     "preCommit": "testbox run",
*     "preCheckout": [
*       "install",
*       "!npm install",
*       "!gulp"
*     ]
*   }
* }
* {code}
*
* If any existing githooks are detected, the installation will be aborted.
* You can pass the `force` argument to override this behavior,
* delete any existing git hooks, and install the package's git hooks anyway.
*/
component {

    property name="githooks" inject="GitHooks@commandbox-githooks";

    /**
    * @force Ignore any installed githooks and overwrite them.
    */
    function run( boolean force = false ) {
        if ( ! githooks.isGitRepo() ) {
            error( "No git repo detected.  Make sure to run this in the root of your project where your git repo is located." );
        }

        if ( force ) {
            print.underscoredWhiteOnRedLine( "DANGER: Force installing!" );
            githooks.deleteExistingHooks( function( hookPath ) {
                print.indentedRed( "x" ).line( " Deleting #listLast( hookPath, "/" )#" );
            } );
        } else {
            var existingHooks = githooks.getExistingHooks();
            if ( ! existingHooks.isEmpty() ) {
                error( "Aborting git hooks installation. Existing git hooks detected: [#existingHooks.toList( ", " )#]." );
                return;
            }
        }

        print.line().underscoredLine( "Installing git hooks" );

        githooks.install( function( hookName ) {
            print.indentedGreen( "+" ).line( " #hookName#" );
        } );

        print.line().boldGreenLine( "Git hooks installed successfully!" ).line();
    }

}
