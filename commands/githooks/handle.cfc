/**
* Handle a git hook through CommandBox
*
* This command looks up the commands to run under the hook name key
* in the `githooks` object in the `box.json`.
* If any of the keys do not exist, nothing is ran.
* The commands can either be a single string or an array of commands.
* If any of the commands returns a non-zero exit code, the execution is stopped.
*/
component {

    property name="githooks" inject="GitHooks@commandbox-githooks";
    property name="packageService" inject="PackageService";
    property name="JSONService" inject="JSONService";

    /**
    * @hookName The hook name to execute
    */
    function run( required string hookName ) {
        var directory = getCWD();

        // Check and see if box.json exists
        if( ! packageService.isPackage( directory ) ) {
            return error( "File [#packageService.getDescriptorPath( directory )#] does not exist." );
        }

        var boxJSON = packageService.readPackageDescriptor( directory );

        if ( ! JSONService.check( boxJSON, "githooks" ) ) {
            return;
        }

        var hooks = JSONService.show( boxJSON, "githooks" );

        if ( ! hooks.keyExists( hookName ) ) {
            return;
        }

        var hookCommands = hooks[ hookName ];
        if ( ! isArray( hookCommands ) ) {
            hookCommands = [ hookCommands ];
        }

        var javaSystem = createObject( 'java', 'java.lang.System' );
        for ( var hookCommand in hookCommands ) {
            command( hookCommand ).run();
            var exitCode = javaSystem.getProperty( 'cfml.cli.exitCode', 0 );
            if ( exitCode != 0 ) {
                return;
            }
        }
    }

}
