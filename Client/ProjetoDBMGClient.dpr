program ProjetoDBMGClient;

uses
  Vcl.Forms,
  frmPrincipal in '..\Units\client\frmPrincipal.pas' {frmTarefas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Gerenciador de Tarefas';
  Application.CreateForm(TfrmTarefas, frmTarefas);
  Application.Run;
end.
