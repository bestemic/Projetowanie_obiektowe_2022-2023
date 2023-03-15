// docker run -it -v ${PWD}:/home/student/projobj/ kprzystalski/projobj-pascal:latest fpc app.pas
// docker run -it -v ${PWD}:/home/student/projobj/ kprzystalski/projobj-pascal:latest ./app

Program app;

Var dataArray: array Of integer;

Procedure generateNumbers(first, last, number : Integer);

Var i : Integer;

Begin
  Randomize;
  SetLength(dataArray, number);

  For i := 0 To number-1 Do
    Begin
      dataArray[i] := Random(last - first + 1) + first;
    End;
End;


Begin
  generateNumbers(0, 100, 50);
End.
