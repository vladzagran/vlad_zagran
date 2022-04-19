# vlad_zagran

program project1;

uses SysUtils, crt, windows;

Type Printer = record
   PrinterType: string[10]; // тип принтера (струйный или лазерный)
   MaxPageYield: Integer; // максимальный ресурс печати картриджа
   CurPageYield: Integer; // остаток ресурса печати картриджа
   TrayCapacity: Integer; // вместимость лотка для бумаги
   CurCapacity: Integer; // текущий остаток бумаги в лотке
   PrintedCounter: Integer; // количество отпечатанных листов
end;

// инициализация полей нового принтера
procedure CreatePrinter(var P: Printer);
begin
  Write('Введите тип принтера: ');
  ReadLn(P.PrinterType);
  Write('Введите значение максимального ресурса печати картриджа: ');
  ReadLn(P.MaxPageYield);
  P.CurPageYield := P.MaxPageYield;    
  Write('Введите значение вместимости лотка для бумаги: ');
  ReadLn(P.TrayCapacity);
  P.CurCapacity := P.TrayCapacity;
  P.PrintedCounter := 0;
  WriteLn('Принтер создан и полностью заправлен!');
end;

// вывод текущего состояния принтера
procedure ShowState(P: Printer);
begin
  WriteLn('Тип принтера: ' + P.PrinterType);
  WriteLn('Максимальный ресурс печати картриджа: ' + IntToStr(P.MaxPageYield));
  WriteLn('Остаток ресурса печати картриджа: ' + IntToStr(P.CurPageYield));
  WriteLn('Максимальная вместимость лотка для бумаги: ' + IntToStr(P.TrayCapacity));
  WriteLn('Остаток бумаги в лотке: ' + IntToStr(P.CurCapacity));
  WriteLn('Количество отпечатанных листов за всё время: ' + IntToStr(P.PrintedCounter));
end;

// заправка картриджа
procedure RefillCartridge(var P: Printer);
begin        
  P.CurPageYield := P.MaxPageYield;
  WriteLn('Картридж заправлен, остаток ресурса печати: ' + IntToStr(P.CurPageYield));
end;

// добавление бумаги в лоток
procedure RefillPaper(var P: Printer);
var x: Integer;
begin
  Write('Введите количество бумаги, которое хотите добавить: ');
  ReadLn(x);
  if P.CurCapacity + x <= P.TrayCapacity then // если вся бумага вместилась
    P.CurCapacity := P.CurCapacity + x // просто увеличиваем текущее значение
  else begin
    x := x + P.CurCapacity - P.TrayCapacity; // вычисляем остаток бумаги
    P.CurCapacity := P.TrayCapacity; // считаем что лоток полон
    WriteLn('Вся бумага не поместилась в лоток, осталось листов: ' + IntToStr(x));
  end;
  WriteLn('Остаток бумаги пополнен, текущий остаток: ' + IntToStr(P.CurCapacity));
end;

// печать
procedure Print(var P: Printer);
var x, y, t, r: Integer;
begin         
  Write('Введите количество печатаемых страниц: ');
  ReadLn(x);
  t := P.PrintedCounter;
  while x > 0 do
  begin
    if (x <= P.CurPageYield) and (x <= P.CurCapacity) then
    begin // если хватает и бумаги и чернил
      P.CurPageYield := P.CurPageYield - x; // уменьшаем остаток чернил
      P.CurCapacity := P.CurCapacity - x; // уменьшаем остаток бумаги
      P.PrintedCounter := P.PrintedCounter + x; // увеличиваем счётчик
      x := 0; // больше печатать не надо
    end
    else if (x > P.CurPageYield) and (P.CurPageYield <= P.CurCapacity) then
    begin // если чернила заканчиваются раньше
      y := P.CurPageYield; // запоминаем на сколько страниц хватило чернил
      P.CurCapacity := P.CurCapacity - y; // пересчитываем количество листов
      P.CurPageYield := 0; // чернил не осталось
      P.PrintedCounter := P.PrintedCounter + y; // увеличиваем счётчик напечатанного
      x := x - y; // сколько осталось напечатать
      Write('В принтере закончились чернила. Заправить? (1-Да, 0-Нет): ');
      ReadLn(r);
      if r = 1 then
      begin
        WriteLn('Выполняется заправка картриджа...');
        RefillCartridge(P); // заполняем картридж
      end
      else begin
        WriteLn('Заправка картриджа отклонена');
        x := 0; // больше не будем печатать
      end;
    end
    else if (x > P.CurCapacity) and (P.CurPageYield >= P.CurCapacity) then
    begin // если бумага заканчивается раньше
      y := P.CurCapacity; // запоминаем на сколько страниц хватило бумаги
      P.CurPageYield := P.CurPageYield - y; // пересчитываем остаток чернил
      P.CurCapacity := 0; // бумаги не осталось
      P.PrintedCounter := P.PrintedCounter + y; // увеличиваем счётчик напечатанного
      x := x - y; // сколько осталось напечатать
      Write('В принтере закончилась бумага. Добавить? (1-Да, 0-Нет): ');
      ReadLn(r);
      if r = 1 then
      begin
        WriteLn('Выполняется добавление бумаги...');
        RefillPaper(P); // добавляем бумагу
      end
      else begin
        WriteLn('Добавление бумаги отклонено');
        x := 0; // больше не будем печатать
      end;
    end;
  end;
  WriteLn('Печать окончена, напечатано листов: ' + IntToStr(P.PrintedCounter - t));
  WriteLn('Остаток ресурса печати картриджа: ' + IntToStr(P.CurPageYield));
  WriteLn('Остаток бумаги в лотке: ' + IntToStr(P.CurCapacity));   
  WriteLn('Количество отпечатанных листов за всё время: ' + IntToStr(P.PrintedCounter));
end;

// вывод меню
function Menu: Integer;
var n: Integer;
begin             
  ClrScr;
  n := 0;
  repeat
    WriteLn('Выберите действие');
    WriteLn('1 - Создать новый принтер');
    WriteLn('2 - Печать');
    WriteLn('3 - Заправить картридж');
    WriteLn('4 - Добавить бумагу в лоток');
    WriteLn('5 - Отобразить текущее состояние');
    WriteLn('6 - Выход');
    Write('> ');
    ReadLn(n);
    if (n < 1) or (n > 6) then
    begin
      WriteLn('Некорректное значение, повторите ввод');
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
      6: WriteLn('Завершение работы');
    end;
    Write('Нажмите любую клавишу...');
    ReadLn;
  until m = 6;
end.


