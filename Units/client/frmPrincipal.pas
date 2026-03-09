unit frmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON;

type
  TfrmTarefas = class(TForm)
    pnlMain: TPanel;
    Panel1: TPanel;
    btnEstatísticas: TButton;
    btnExcluir: TButton;
    btnConcluir: TButton;
    btnAdicionar: TButton;
    btnCarregar: TButton;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    GridTarefas: TStringGrid;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnEstatísticasClick(Sender: TObject);
  private
    procedure CarregarTarefas;
    procedure ExcluirTarefa;
    procedure ConcluirTarefa;
    procedure AdicionarTarefa;
    procedure MostrarEstatisticas;
  public
    { Public declarations }
  end;

var
  frmTarefas: TfrmTarefas;

implementation

{$R *.dfm}

procedure TfrmTarefas.AdicionarTarefa;
var
  Json: TJSONObject;
  Titulo,
  Descricao,
  PrioridadeStr: string;
  Prioridade: Integer;
begin
  // Solicita e valida Título
  Titulo := Trim(InputBox('Título', 'Digite o título da tarefa', ''));
  if Titulo = '' then
  begin
    MessageDlg('Processo cancelado ou título vazio!', mtWarning, [mbOK], 0);
    Exit;
  end;

  // Solicita e valida Descrição
  Descricao := Trim(InputBox('Descrição', 'Digite a descrição da tarefa', ''));
  if Descricao = '' then
  begin
    MessageDlg('Processo cancelado ou descrição vazia!', mtWarning, [mbOK], 0);
    Exit;
  end;

  // Solicita e valida Prioridade
  PrioridadeStr := Trim(InputBox('Prioridade', 'Digite a prioridade (1 a 5)', ''));
  if PrioridadeStr = '' then
  begin
    MessageDlg('Processo cancelado ou prioridade não informada!', mtWarning, [mbOK], 0);
    Exit;
  end;

  Prioridade := StrToIntDef(PrioridadeStr, 0);
  if (Prioridade < 1) or (Prioridade > 5) then
  begin
    MessageDlg('A prioridade deve estar entre 1 e 5!', mtWarning, [mbOK], 0);
    Exit;
  end;

  // Apenas depois de tudo validado, cria e envia o JSON
  Json := TJSONObject.Create;
  try
    Json.AddPair('titulo', Titulo);
    Json.AddPair('descricao', Descricao);
    Json.AddPair('prioridade', TJSONNumber.Create(Prioridade));

    RESTRequest.Resource := 'tarefas';
    RESTRequest.Method := rmPOST;
    RESTRequest.ClearBody;
    RESTRequest.AddBody(Json.ToJSON, ctAPPLICATION_JSON);
    RESTRequest.Execute;

    CarregarTarefas; // Atualiza o grid
  finally
    Json.Free;
  end;
end;

procedure TfrmTarefas.btnAdicionarClick(Sender: TObject);
begin
  AdicionarTarefa;
end;

procedure TfrmTarefas.btnConcluirClick(Sender: TObject);
begin
  ConcluirTarefa;
end;

procedure TfrmTarefas.btnEstatísticasClick(Sender: TObject);
begin
  MostrarEstatisticas;
end;

procedure TfrmTarefas.btnExcluirClick(Sender: TObject);
begin
  ExcluirTarefa;
end;

procedure TfrmTarefas.btnCarregarClick(Sender: TObject);
begin
  CarregarTarefas;
end;

procedure TfrmTarefas.CarregarTarefas;
var
  JsonArray: TJSONArray;
  Obj: TJSONObject;
  I: Integer;
begin
  RESTRequest.Resource := 'tarefas';
  RESTRequest.Method := rmGET;
  RESTRequest.Execute;

  JsonArray := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONArray;

  gridTarefas.RowCount := JsonArray.Count + 1;

  for I := 0 to JsonArray.Count - 1 do
  begin
    Obj := JsonArray.Items[I] as TJSONObject;

    gridTarefas.Cells[0,I+1] := Obj.GetValue<string>('id');
    gridTarefas.Cells[1,I+1] := Obj.GetValue<string>('titulo');
    gridTarefas.Cells[2,I+1] := Obj.GetValue<string>('descricao');
    gridTarefas.Cells[3,I+1] := Obj.GetValue<string>('prioridade');
    gridTarefas.Cells[4,I+1] := Obj.GetValue<string>('status');
  end;

  gridTarefas.Col := 0;

  if JsonArray.Count > 0 then
    gridTarefas.Row := 1
  else
    gridTarefas.Row := 0;
end;

procedure TfrmTarefas.ConcluirTarefa;
var
  Id: string;
begin
  if gridTarefas.Row = 0 then
  begin
    ShowMessage('Selecione uma tarefa para concluir.');
    Exit;
  end;

  Id := gridTarefas.Cells[0, gridTarefas.Row];

  if MessageDlg('Deseja realmente concluir a tarefa de ID ' + Id + '?',
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  RESTRequest.Resource := 'tarefas/' + Id;
  RESTRequest.Method := rmPUT;
  RESTRequest.Execute;

  CarregarTarefas;
end;

procedure TfrmTarefas.ExcluirTarefa;
var
  Id: string;
begin
  if gridTarefas.Row = 0 then
  begin
    ShowMessage('Selecione uma tarefa para concluir.');
    Exit;
  end;

  Id := gridTarefas.Cells[0, gridTarefas.Row];

  if MessageDlg('Deseja realmente excluir a tarefa de ID ' + Id + '?',
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  RESTRequest.Resource := 'tarefas/' + Id;
  RESTRequest.Method := rmDELETE;
  RESTRequest.Execute;

  CarregarTarefas;
end;

procedure TfrmTarefas.FormCreate(Sender: TObject);
begin
  gridTarefas.RowCount := 1;

  //gridTarefas.FixedRows := 1;

  gridTarefas.Cells[0,0] := 'ID';
  gridTarefas.Cells[1,0] := 'Título';
  gridTarefas.Cells[2,0] := 'Descrição';
  gridTarefas.Cells[3,0] := 'Prioridade';
  gridTarefas.Cells[4,0] := 'Status';

  gridTarefas.ColWidths[0] := 50;
  gridTarefas.ColWidths[1] := 150;
  gridTarefas.ColWidths[2] := 250;
  gridTarefas.ColWidths[3] := 80;
  gridTarefas.ColWidths[4] := 100;

  gridTarefas.ColCount := 5;

end;

procedure TfrmTarefas.MostrarEstatisticas;
var
  Json: TJSONObject;
  Msg: string;
begin
  RESTRequest.Resource := 'estatisticas';
  RESTRequest.Method := rmGET;
  RESTRequest.Execute;

  Json := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;

  Msg :=
    'ESTATÍSTICAS DAS TAREFAS' + sLineBreak +
    '-----------------------------------' + sLineBreak +
    'Total de tarefas: ' + Json.GetValue<string>('total') + sLineBreak +
    'Média prioridade pendente: ' + Json.GetValue<string>('media_prioridade') + sLineBreak +
    'Concluídas nos últimos 7 dias: ' + Json.GetValue<string>('concluidas_7_dias');

  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

end.
