unit connection.factory;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

function GetConnection: TFDConnection;

implementation

function GetConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.DriverName := 'MSSQL';

  Result.Params.Values['Server'] := 'localhost';
  Result.Params.Values['Database'] := 'DBMG';
  Result.Params.Values['OSAuthent'] := 'Yes';

  Result.LoginPrompt := False;
  Result.Connected := True;
end;

end.
