 
 /*------------------------------------------------------------------------
    File        : SessionHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : qa-3pthinc
    Created     : Mon Feb 03 15:07:28 CET 2020
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.SessionHelper: 
  /*------------------------------------------------------------------------------
        Purpose: Returns the "bitness" of the current process (32 / 64 bit)
        Notes:
        @return 32 or 64 depending on the current Process process
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC INTEGER ProcessBitness ():

        &IF DEFINED (DotNetAccessible) NE 0 &THEN

        &IF PROVERSION BEGINS "10" &THEN
        RETURN 32 . /* no 64 bit Progress on Windows on OE10 */
        &ELSE
        IF System.Environment:Is64BitProcess THEN
            RETURN 64.
        ELSE
            RETURN 32.
        &ENDIF

        &ELSE
        RETURN 64. /* no 32 bit Progress on Linux anymore */
        &ENDIF

    END METHOD .

END CLASS.