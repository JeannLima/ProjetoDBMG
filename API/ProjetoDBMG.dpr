program ProjetoDBMG;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  controller.tarefas in '..\Units\api-horse\controller.tarefas.pas',
  connection.factory in '..\Units\api-horse\connection.factory.pas';

begin
  Writeln('Iniciando API...');
  THorse.Get('/tarefas', GetTarefas);
  THorse.Post('/tarefas', AddTarefa);
  THorse.Put('/tarefas/:id', UpdateTarefa);
  THorse.Delete('/tarefas/:id', DeleteTarefa);
  THorse.Get('/estatisticas', GetEstatisticas);

  Sleep(100);
  THorse.Listen(9000);
end.
