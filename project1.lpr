program project1;

uses SysUtils, crt, windows;

Type Printer = record
   PrinterType: string[10]; // ��� �������� (�������� ��� ��������)
   MaxPageYield: Integer; // ������������ ������ ������ ���������
   CurPageYield: Integer; // ������� ������� ������ ���������
   TrayCapacity: Integer; // ����������� ����� ��� ������
   CurCapacity: Integer; // ������� ������� ������ � �����
   PrintedCounter: Integer; // ���������� ������������ ������
end;

// ������������� ����� ������ ��������
procedure CreatePrinter(var P: Printer);
begin
  Write('������� ��� ��������: ');
  ReadLn(P.PrinterType);
  Write('������� �������� ������������� ������� ������ ���������: ');
  ReadLn(P.MaxPageYield);
  P.CurPageYield := P.MaxPageYield;    
  Write('������� �������� ����������� ����� ��� ������: ');
  ReadLn(P.TrayCapacity);
  P.CurCapacity := P.TrayCapacity;
  P.PrintedCounter := 0;
  WriteLn('������� ������ � ��������� ���������!');
end;

// ����� �������� ��������� ��������
procedure ShowState(P: Printer);
begin
  WriteLn('��� ��������: ' + P.PrinterType);
  WriteLn('������������ ������ ������ ���������: ' + IntToStr(P.MaxPageYield));
  WriteLn('������� ������� ������ ���������: ' + IntToStr(P.CurPageYield));
  WriteLn('������������ ����������� ����� ��� ������: ' + IntToStr(P.TrayCapacity));
  WriteLn('������� ������ � �����: ' + IntToStr(P.CurCapacity));
  WriteLn('���������� ������������ ������ �� �� �����: ' + IntToStr(P.PrintedCounter));
end;

// �������� ���������
procedure RefillCartridge(var P: Printer);
begin        
  P.CurPageYield := P.MaxPageYield;
  WriteLn('�������� ���������, ������� ������� ������: ' + IntToStr(P.CurPageYield));
end;

// ���������� ������ � �����
procedure RefillPaper(var P: Printer);
var x: Integer;
begin
  Write('������� ���������� ������, ������� ������ ��������: ');
  ReadLn(x);
  if P.CurCapacity + x <= P.TrayCapacity then // ���� ��� ������ ����������
    P.CurCapacity := P.CurCapacity + x // ������ ����������� ������� ��������
  else begin
    x := x + P.CurCapacity - P.TrayCapacity; // ��������� ������� ������
    P.CurCapacity := P.TrayCapacity; // ������� ��� ����� �����
    WriteLn('��� ������ �� ����������� � �����, �������� ������: ' + IntToStr(x));
  end;
  WriteLn('������� ������ ��������, ������� �������: ' + IntToStr(P.CurCapacity));
end;

// ������
procedure Print(var P: Printer);
var x, y, t, r: Integer;
begin         
  Write('������� ���������� ���������� �������: ');
  ReadLn(x);
  t := P.PrintedCounter;
  while x > 0 do
  begin
    if (x <= P.CurPageYield) and (x <= P.CurCapacity) then
    begin // ���� ������� � ������ � ������
      P.CurPageYield := P.CurPageYield - x; // ��������� ������� ������
      P.CurCapacity := P.CurCapacity - x; // ��������� ������� ������
      P.PrintedCounter := P.PrintedCounter + x; // ����������� �������
      x := 0; // ������ �������� �� ����
    end
    else if (x > P.CurPageYield) and (P.CurPageYield <= P.CurCapacity) then
    begin // ���� ������� ������������� ������
      y := P.CurPageYield; // ���������� �� ������� ������� ������� ������
      P.CurCapacity := P.CurCapacity - y; // ������������� ���������� ������
      P.CurPageYield := 0; // ������ �� ��������
      P.PrintedCounter := P.PrintedCounter + y; // ����������� ������� �������������
      x := x - y; // ������� �������� ����������
      Write('� �������� ����������� �������. ���������? (1-��, 0-���): ');
      ReadLn(r);
      if r = 1 then
      begin
        WriteLn('����������� �������� ���������...');
        RefillCartridge(P); // ��������� ��������
      end
      else begin
        WriteLn('�������� ��������� ���������');
        x := 0; // ������ �� ����� ��������
      end;
    end
    else if (x > P.CurCapacity) and (P.CurPageYield >= P.CurCapacity) then
    begin // ���� ������ ������������� ������
      y := P.CurCapacity; // ���������� �� ������� ������� ������� ������
      P.CurPageYield := P.CurPageYield - y; // ������������� ������� ������
      P.CurCapacity := 0; // ������ �� ��������
      P.PrintedCounter := P.PrintedCounter + y; // ����������� ������� �������������
      x := x - y; // ������� �������� ����������
      Write('� �������� ����������� ������. ��������? (1-��, 0-���): ');
      ReadLn(r);
      if r = 1 then
      begin
        WriteLn('����������� ���������� ������...');
        RefillPaper(P); // ��������� ������
      end
      else begin
        WriteLn('���������� ������ ���������');
        x := 0; // ������ �� ����� ��������
      end;
    end;
  end;
  WriteLn('������ ��������, ���������� ������: ' + IntToStr(P.PrintedCounter - t));
  WriteLn('������� ������� ������ ���������: ' + IntToStr(P.CurPageYield));
  WriteLn('������� ������ � �����: ' + IntToStr(P.CurCapacity));   
  WriteLn('���������� ������������ ������ �� �� �����: ' + IntToStr(P.PrintedCounter));
end;

// ����� ����
function Menu: Integer;
var n: Integer;
begin             
  ClrScr;
  n := 0;
  repeat
    WriteLn('�������� ��������');
    WriteLn('1 - ������� ����� �������');
    WriteLn('2 - ������');
    WriteLn('3 - ��������� ��������');
    WriteLn('4 - �������� ������ � �����');
    WriteLn('5 - ���������� ������� ���������');
    WriteLn('6 - �����');
    Write('> ');
    ReadLn(n);
    if (n < 1) or (n > 6) then
    begin
      WriteLn('������������ ��������, ��������� ����');
      n := 0;
    end;
  until n > 0;
  Menu := n;
end;

var
  prntr: Printer;
  m: Integer;
begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  repeat
    m := Menu;
    case m of
      1: CreatePrinter(prntr);
      2: Print(prntr);        
      3: RefillCartridge(prntr);
      4: RefillPaper(prntr);
      5: ShowState(prntr);
      6: WriteLn('���������� ������');
    end;
    Write('������� ����� �������...');
    ReadLn;
  until m = 6;
end.


