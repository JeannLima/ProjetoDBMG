unit controller.tarefas;

interface

uses
   Horse, System.JSON, System.SysUtils;

procedure GetTarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure AddTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure UpdateTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetEstatisticas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses connection.factory, FireDAC.Comp.Client;

procedure GetTarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Conn: TFDConnection;
  Q: TFDQuery;
  JSONArray: TJSONArray;
  Obj: TJSONObject;
begin
  Conn := GetConnection;
  Q := TFDQuery.Create(nil);
  JSONArray := TJSONArray.Create;

  try
    Q.Connection := Conn;
    Q.SQL.Text := 'SELECT * FROM Tarefas';
    Q.Open;

    while not Q.Eof do
    begin
      Obj := TJSONObject.Create;

      Obj.AddPair('id', Q.FieldByName('Id').AsString);
      Obj.AddPair('titulo', Q.FieldByName('Titulo').AsString);
      Obj.AddPair('descricao', Q.FieldByName('Descricao').AsString);
      Obj.AddPair('prioridade', Q.FieldByName('Prioridade').AsString);
      Obj.AddPair('status', Q.FieldByName('Status').AsString);

      JSONArray.AddElement(Obj);
      Q.Next;
    end;

    Res
      .Status(200)
      .ContentType('application/json')
      .Send(JSONArray.ToJSON);

  finally
    Q.Free;
    Conn.Free;
  end;
end;

procedure AddTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Conn: TFDConnection;
  Q: TFDQuery;
  Body: TJSONObject;
begin
  Body := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

  if Body = nil then
  begin
    Res.Status(400).Send('JSON inválido');
    Exit;
  end;

  Conn := GetConnection;
  Q := TFDQuery.Create(nil);

  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'INSERT INTO Tarefas (Titulo,Descricao,Prioridade,Status) '+
      'VALUES (:T,:D,:P,:S)';

    Q.ParamByName('T').AsString := Body.GetValue<string>('titulo');
    Q.ParamByName('D').AsString := Body.GetValue<string>('descricao');
    Q.ParamByName('P').AsInteger := Body.GetValue<Integer>('prioridade');
    Q.ParamByName('S').AsString := 'Pendente';

    Q.ExecSQL;

    Res.Status(201).Send('Criado');
  finally
    Body.Free;
    Q.Free;
    Conn.Free;
  end;
end;

procedure UpdateTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Conn: TFDConnection;
  Q: TFDQuery;
  Id: String;
begin
  Id := Req.Params['id'];

  Conn := GetConnection;
  Q := TFDQuery.Create(nil);

  try
    Q.Connection := Conn;

    Q.SQL.Text :=
      'UPDATE Tarefas SET Status = ''Concluida'', DataConclusao = GETDATE() '+
      'WHERE Id = :Id';

    Q.ParamByName('Id').AsInteger := StrToInt(Id);
    Q.ExecSQL;

    Res.Send('Atualizado');
  finally
    Q.Free;
    Conn.Free;
  end;
end;

procedure DeleteTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Conn: TFDConnection;
  Q: TFDQuery;
  Id: String;
begin
  Id := Req.Params['id'];

  Conn := GetConnection;
  Q := TFDQuery.Create(nil);

  try
    Q.Connection := Conn;

    Q.SQL.Text := 'DELETE FROM Tarefas WHERE Id = :Id';
    Q.ParamByName('Id').AsInteger := StrToInt(Id);
    Q.ExecSQL;

    Res.Send('Removido');
  finally
    Q.Free;
    Conn.Free;
  end;
end;

procedure GetEstatisticas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Conn: TFDConnection;
  Q: TFDQuery;
  Json: TJSONObject;
begin
  Conn := GetConnection;
  Q := TFDQuery.Create(nil);
  Json := TJSONObject.Create;

  try
    Q.Connection := Conn;

    Q.SQL.Text := 'SELECT COUNT(*) Total FROM Tarefas';
    Q.Open;
    Json.AddPair('total', Q.FieldByName('Total').AsString);

    Q.SQL.Text :=
      'SELECT AVG(Prioridade) Media FROM Tarefas WHERE Status=''Pendente''';
    Q.Open;
    Json.AddPair('media_prioridade', Q.FieldByName('Media').AsString);

    Q.SQL.Text :=
      'SELECT COUNT(*) Concluidas FROM Tarefas '+
      'WHERE DataConclusao >= DATEADD(DAY,-7,GETDATE())';
    Q.Open;
    Json.AddPair('concluidas_7_dias', Q.FieldByName('Concluidas').AsString);

    //Res.ContentType('application/json').Send(Json);
    Res.ContentType('application/json').Send(Json.ToJSON);
  finally
    Q.Free;
    Conn.Free;
  end;
end;

end.
