component {

    property name="fileSystemUtil" inject="FileSystem";

    variables.availableHooks = {
        "applyPatchMsg"    = "applypatch-msg",
        "preApplyPatch"    = "pre-applypatch",
        "postApplyPatch"   = "post-applypatch",
        "preCommit"        = "pre-commit",
        "prepareCommitMsg" = "prepare-commit-msg",
        "commitMsg"        = "commit-msg",
        "postCommit"       = "post-commit",
        "preRebase"        = "pre-rebase",
        "postCheckout"     = "post-checkout",
        "postMerge"        = "post-merge",
        "preReceive"       = "pre-receive",
        "update"           = "update",
        "postReceive"      = "post-receive",
        "postUpdate"       = "post-update",
        "preAutoGc"        = "pre-auto-gc",
        "postRewrite"      = "post-rewrite",
        "prePush"          = "pre-push",
    };

    function onDIComplete() {
        variables.baseDirectory = fileSystemUtil.resolvePath( "" );
        variables.gitDirectory = variables.baseDirectory & "/.git/";
        variables.hooksDirectory = variables.gitDirectory & "/hooks/";
    }

    function isGitRepo() {
        return directoryExists( variables.gitDirectory );
    }

    function getExistingHooks( listInfo = "name" ) {
        return directoryList( path = variables.hooksDirectory, listInfo = arguments.listInfo )
            .filter( function( hookName ) {
                return ! findNoCase( ".sample", hookName );
            } );
    }

    function deleteExistingHooks( callback ) {
        getExistingHooks( listInfo = "path" ).each( function( hookPath ) {
            fileDelete( hookPath );
            if ( ! isNull( callback ) ) {
                callback( hookPath );
            }
        } );
    }

    function install( callback ) {
        for ( var key in variables.availableHooks ) {
            var hookName = variables.availableHooks[ key ];
            var template = fileRead( expandPath( "/commandbox-githooks/resources/hook-template") );
            template = replaceNoCase( template, "{{hookName}}", key, "all" );
            cffile(
                action = "write",
                file = variables.hooksDirectory & hookName,
                mode = "0755",
                output = template
            );
            if ( ! isNull( callback ) ) {
                callback( key, hookName, template );
            }
        }
    }

}
