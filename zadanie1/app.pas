
Program app;


Procedure generateNumbers(Var data: Array Of Integer; first, last, size :
                          Integer);

Var i, tmp : Integer;

Begin
  If size < 0 Then
    Begin
      writeln('ERROR: Number of elements to generate cannot be negative');
      exit;
    End;

  If first>last Then
    Begin
      tmp := last;
      last := first;
      first := tmp;
    End;

  For i := 0 To size-1 Do
    Begin
      data[i] := Random(last - first + 1) + first;
    End;
End;

Procedure sortArray(Var data: Array Of Integer);

Var i,j,tmp: integer;

Begin
  For i := 0 To Length(data)-2 Do
    For j := 0 To Length(data)-2 Do
      Begin
        If (data[j] > data[j+1]) Then
          Begin
            tmp := data[j];
            data[j] := data[j+1];
            data[j+1] := tmp;
          End;
      End;
End;

Procedure print(Var data: Array Of Integer);

Var i: integer;

Begin
  For i := 0 To Length(data)-1 Do
    Begin
      Write(data[i], ' ');
    End;
  Writeln();
End;

Procedure test_sort_sorted_array();

Var 
  input: array[0..9] Of integer = (-4,-3,-2,-1,0,1,2,3,4,5);
  expected: array[0..9] Of integer = (-4,-3,-2,-1,0,1,2,3,4,5);
  passed: boolean = true;
  i: integer;

Begin
  sortArray(input);

  For i := 0 To Length(input)-1 Do
    Begin
      If input[i] <> expected[i] Then
        Begin
          passed := false;
          break
        End
    End;

  write('Test sort sorted array ');
  If (passed) Then
    writeln('PASSED')
  Else
    writeln('FAILED');
End;

Procedure test_sort_reverse_sorted_array();

Var 
  input: array[0..9] Of integer = (4,3,2,1,0,-1,-2,-3,-4,-5);
  expected: array[0..9] Of integer = (-5,-4,-3,-2,-1,0,1,2,3,4);
  passed: boolean = true;
  i: integer;

Begin
  sortArray(input);

  For i := 0 To Length(input)-1 Do
    Begin
      If input[i] <> expected[i] Then
        Begin
          passed := false;
          break
        End
    End;

  write('Test sort reverse sorted array ');
  If (passed) Then
    writeln('PASSED')
  Else
    writeln('FAILED');
End;

Procedure test_sort_random_array();

Var 
  input: array[0..9] Of integer = (1,-4,5,0,-1,-2,3,-3,2,4);
  expected: array[0..9] Of integer = (-4,-3,-2,-1,0,1,2,3,4,5);
  passed: boolean = true;
  i: integer;

Begin
  sortArray(input);

  For i := 0 To Length(input)-1 Do
    Begin
      If input[i] <> expected[i] Then
        Begin
          passed := false;
          break
        End
    End;

  write('Test sort random array ');
  If (passed) Then
    writeln('PASSED')
  Else
    writeln('FAILED');
End;

Procedure test_generate_negative_number_of_elements();

Var 
  dataArray: array Of integer;

Begin
  SetLength(dataArray, 1);
  generateNumbers(dataArray, 1, 1, -1);

  write('Test generate negative number of elements ');
  If (dataArray[1]=0) Then
    writeln('PASSED')
  Else
    writeln('FAILED');
End;

Procedure test_generate_numbers_in_given_range();

Var 
  dataArray: array Of integer;
  passed: boolean = true;
  i: integer;
  min: integer = 25;
  max: integer = 50;
  size: integer = 100;

Begin
  SetLength(dataArray, size);
  generateNumbers(dataArray, min, max, size);

  For i := 0 To Length(dataArray)-1 Do
    Begin
      If (dataArray[i] < min) Or (dataArray[i] > max)  Then
        Begin
          passed := false;
          break
        End
    End;

  write('Test generate numbers in given range ');
  If (passed) Then
    writeln('PASSED')
  Else
    writeln('FAILED');
End;

Var 
  dataArray: array Of integer;
  size: integer = 50;
Begin
  randomize;
  SetLength(dataArray, size);
  Writeln('Generated numbers:');
  generateNumbers(dataArray, 0, 100, size);
  print(dataArray);

  writeln('Numbers after sorting:');
  sortArray(dataArray);
  print(dataArray);

  Writeln();
  Writeln('STARTING TESTS:');

  test_sort_sorted_array();
  test_sort_reverse_sorted_array();
  test_sort_random_array();
  test_generate_negative_number_of_elements();
  test_generate_numbers_in_given_range();
End.
