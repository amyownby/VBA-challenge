Sub Challenge2()

'Run Process on all worksheets
Dim ws As Worksheet
For Each ws In ThisWorkbook.Worksheets
ws.Activate

'------------------------------------------

    'this speeds up macro processing
    Application.ScreenUpdating = False

    'set all variables
    Dim Ticker As String
    Dim Ticker_Volume As Double
        Ticker_Volume = 0
    Dim Ticker_Open As Double
        Ticker_Open = 0
    Dim Ticker_Close As Double
        Ticker_Close = 0
    Dim Yearly_Change As Double
        Yearly_Change = 0
    Dim Percent_Change As Double
        Percent_Change = 0
        
    'set headers
    Range("I1").Value = "Ticker"
    Range("J1").Value = "Yearly Change"
    Range("K1").Value = "Percent Change"
    Range("L1").Value = "Total Stock Volume"
    
    Range("O1").Value = "Ticker"
    Range("P1").Value = "Value"
    
    Range("N2").Value = "Greatest % Increase"
    Range("N3").Value = "Greatest % Decrease"
    Range("N4").Value = "Greatest Total Volume"
  
    'set variable for last row
    Dim LastRow As Long
    LastRow = Cells(Rows.Count, 1).End(xlUp).Row

    'location for each ticker name
    Dim Summary_Table_Row As Integer
    Summary_Table_Row = 2

    'loop through all line items
    For i = 2 To LastRow

    If Cells(i - 1, 1).Value <> Cells(i, 1).Value Then

            'set ticker open
            Ticker_Open = Cells(i, 3).Value
            
            'set ticker volume
            Ticker_Volume = Ticker_Volume + Cells(i, 7).Value

    'check if value is within the same ticker name
    ElseIf Cells(i + 1, 1).Value <> Cells(i, 1).Value Then
            
            'set ticker name
            Ticker = Cells(i, 1).Value

            'set ticker close
            Ticker_Close = Ticker_Close + Cells(i, 6).Value
      
            'set the yearly change
            Yearly_Change = Ticker_Close - Ticker_Open
      
            'set the percent change
            Percent_Change = (((Ticker_Close - Ticker_Open) / Ticker_Open))

            'add to the ticker volume
            Ticker_Volume = Ticker_Volume + Cells(i, 7).Value

            'print the summary table
            Range("I" & Summary_Table_Row).Value = Ticker
            Range("J" & Summary_Table_Row).Value = Yearly_Change
            Range("K" & Summary_Table_Row).Value = Percent_Change
            Range("L" & Summary_Table_Row).Value = Ticker_Volume

            'add one to the summary table row
            Summary_Table_Row = Summary_Table_Row + 1
      
            'reset the totals
            Ticker_Close = 0
            Ticker_Volume = 0

        Else

            'add to the ticker volume
            Ticker_Volume = Ticker_Volume + Cells(i, 7).Value

        End If

    Next i

'---------------------------------------------------------

    'format positive and negative yearly changes
    Dim YearRange As Range
    Set YearRange = Range("J:K")
    
    For Each Cell In YearRange
        If Cell.Value < 0 Then
            Cell.Interior.ColorIndex = 3
        ElseIf Cell.Value > 0 Then
            Cell.Interior.ColorIndex = 4
        End If
    Next

    'format percent change as percentage
    Range("K:K").NumberFormat = "0.00%"
    
'---------------------------------------------------------

    'create the other table with the highest and lowest
    Dim Per_Inc As Double
    Dim Per_Dec As Double
    Dim Tot_Vol As Double
    
    'set range to determine searches
    Search_Percent = Range("K:K")
    Search_Volume = Range("L:L")

    'use min max to find the values
    Per_Inc = Application.WorksheetFunction.Max(Search_Percent)
        Cells(2, 16).Value = Per_Inc
        
    Per_Dec = Application.WorksheetFunction.Min(Search_Percent)
        Cells(3, 16).Value = Per_Dec
        
    Tot_Vol = Application.WorksheetFunction.Max(Search_Volume)
        Cells(4, 16).Value = Tot_Vol

    'use match function to find the ticker names
    Dim Tic_Inc As Double
    Tic_Inc = WorksheetFunction.Match(WorksheetFunction.Max(Range("K2:K" & LastRow)), Range("K2:K" & LastRow), 0)
        Range("O2") = Cells(Tic_Inc + 1, 9)

    Dim Tic_Dec As Double
    Tic_Dec = WorksheetFunction.Match(WorksheetFunction.Min(Range("K2:K" & LastRow)), Range("K2:K" & LastRow), 0)
        Range("O3") = Cells(Tic_Dec + 1, 9)

    Dim Tic_Tot As Double
    Tic_Tot = WorksheetFunction.Match(WorksheetFunction.Max(Range("L2:L" & LastRow)), Range("L2:L" & LastRow), 0)
        Range("O4") = Cells(Tic_Tot + 1, 9)
    
    'format percents
    Range("P2:P3").NumberFormat = "0.00%"
    
'---------------------------------------------------------
    
    'close what speeds up macro processing
    Application.ScreenUpdating = True
    
'loop process on all worksheets
Next ws
    
End Sub
