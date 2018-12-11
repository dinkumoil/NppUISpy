'==============================================================================
'
' Class for parsing JSON files
'
' Author: Andreas Heim
' Date:   30.06.2016
'
' Implementation as Finite State Machine
'
' This file is part of the deployment system of the plugin framework for Delphi.
'
' This program is free software; you can redistribute it and/or modify it
' under the terms of the GNU General Public License version 3 as published
' by the Free Software Foundation.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License along
' with this program; if not, write to the Free Software Foundation, Inc.,
' 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
'
'==============================================================================


Const EolStyleWindows    = 0
Const EolStyleUnix       = 1

Const IndentStyleSpace   = 0
Const IndentStyleTab     = 1

Const BracketStyleAllman = 0
Const BracketStyleJava   = 1


Class clsJsonFile
  Private intContextLookup
  Private intStateError
  Private intStateAwaitKey
  Private intStateReadKey
  Private intStateKeyRead
  Private intStateAwaitValue
  Private intStateReadConst
  Private intStateConstRead
  Private intStateReadNumber
  Private intStateNumberRead
  Private intStateReadString
  Private intStateReadEscapeChar
  Private intStateStringRead
  Private intStateReadArray
  Private intStateArrayRead
  Private intStateReadObject
  Private intStateObjectRead

  Private arrStateAwaitKey,   arrStateAwaitValue
  Private arrStateReadKey,    arrStateKeyRead
  Private arrStateReadConst,  arrStateConstRead
  Private arrStateReadNumber, arrStateNumberRead
  Private arrStateReadString, arrStateReadEscapeChar, arrStateStringRead
  Private arrStateReadArray,  arrStateArrayRead
  Private arrStateReadObject, arrStateObjectRead

  Private arrStateTable

  Private intState
  Private intLCnt
  Private strItem, strKey

  Private objFSO, objRegEx, dicJsonFile
  Private arrStack, intStackPtr
  Private varCurDataStore
  Private intDebugLevel
  Private intEolStyle
  Private intIndent
  Private intIndentStyle
  Private intBracketStyle
  Private bolAllStrValues


  '----------------------------------------------------------------------------
  'Constructor
  '----------------------------------------------------------------------------
  Private Sub Class_Initialize()
    'Debug level
    '  - 0: No debug output
    '  - 1: Brief debug output
    '  - 2: Verbose debug output
    intDebugLevel           = 0

    intEolStyle             = EolStyleWindows
    intBracketStyle         = BracketStyleAllman
    intIndentStyle          = IndentStyleSpace
    intIndent               = 2
    bolAllStrValues         = False

    arrStack                = Array()
    intStackPtr             = -1

    Set objRegEx            = New RegExp
    objRegEx.Global         = False
    objRegEx.IgnoreCase     = True

    Set dicJsonFile         = CreateObject("Scripting.Dictionary")
    dicJsonFile.CompareMode = vbTextCompare

    Set objFSO              = CreateObject("Scripting.FileSystemObject")

    intContextLookup       = -2
    intStateError          = -1
    intStateAwaitKey       =  0
    intStateReadKey        =  1
    intStateKeyRead        =  2
    intStateAwaitValue     =  3
    intStateReadConst      =  4
    intStateConstRead      =  5
    intStateReadNumber     =  6
    intStateNumberRead     =  7
    intStateReadString     =  8
    intStateReadEscapeChar =  9
    intStateStringRead     = 10
    intStateReadArray      = 11
    intStateArrayRead      = 12
    intStateReadObject     = 13
    intStateObjectRead     = 14

    arrStateAwaitKey       = Array("", _
                                   Array("""",          Array(intStateReadKey)) _
                                  )

    arrStateReadKey        = Array("^[^""]*$", _
                                   Array("[^""]",       Array(intStateReadKey)), _
                                   Array("""",          Array(intStateKeyRead))  _
                                  )

    arrStateKeyRead        = Array("", _
                                   Array(":",           Array(intStateAwaitValue)) _
                                  )

    arrStateAwaitValue     = Array("", _
                                   Array("[ntf]",       Array(intStateReadConst)),  _
                                   Array("[0-9-]",      Array(intStateReadNumber)), _
                                   Array("""",          Array(intStateReadString)), _
                                   Array("\[",          Array(intStateReadArray)),  _
                                   Array("\]",          Array(intStateArrayRead)),  _
                                   Array("\{",          Array(intStateReadObject)), _
                                   Array("\}",          Array(intStateObjectRead))  _
                                  )

    arrStateReadConst      = Array("^(null|true|false)$", _
                                   Array("[a-z]",       Array(intStateReadConst)), _
                                   Array(",",           Array(intStateConstRead, intContextLookup)),  _
                                   Array("\]",          Array(intStateConstRead, intStateArrayRead)), _
                                   Array("\}",          Array(intStateConstRead, intStateObjectRead)) _
                                  )

    arrStateConstRead      = Array("", _
                                   Array(",",           Array(intContextLookup)),  _
                                   Array("\]",          Array(intStateArrayRead)), _
                                   Array("\}",          Array(intStateObjectRead)) _
                                  )

    arrStateReadNumber     = Array("^-{0,1}(0|([1-9][0-9]*))(\.[0-9]+)*(E(\+|-){0,1}[0-9]+)*$", _
                                   Array("[0-9\.E\+-]", Array(intStateReadNumber)), _
                                   Array(",",           Array(intStateNumberRead, intContextLookup)),   _
                                   Array("\]",          Array(intStateNumberRead, intStateArrayRead)),  _
                                   Array("\}",          Array(intStateNumberRead, intStateObjectRead))  _
                                  )

    arrStateNumberRead     = Array("", _
                                   Array(",",           Array(intContextLookup)),  _
                                   Array("\]",          Array(intStateArrayRead)), _
                                   Array("\}",          Array(intStateObjectRead)) _
                                  )

    arrStateReadString     = Array("", _
                                   Array("[^\\""]",     Array(intStateReadString)),     _
                                   Array("\\",          Array(intStateReadEscapeChar)), _
                                   Array("""",          Array(intStateStringRead))      _
                                  )

    arrStateReadEscapeChar = Array("", _
                                   Array("\\",          Array(intStateReadString)), _
                                   Array("/",           Array(intStateReadString)), _
                                   Array("""",          Array(intStateReadString)), _
                                   Array("b",           Array(intStateReadString)), _
                                   Array("f",           Array(intStateReadString)), _
                                   Array("n",           Array(intStateReadString)), _
                                   Array("r",           Array(intStateReadString)), _
                                   Array("t",           Array(intStateReadString)), _
                                   Array("u",           Array(intStateReadString))  _
                                  )

    arrStateStringRead     = Array("", _
                                   Array(",",           Array(intContextLookup)),  _
                                   Array("\]",          Array(intStateArrayRead)), _
                                   Array("\}",          Array(intStateObjectRead)) _
                                  )

    arrStateReadArray      = Array("", _
                                   Array("[ntf]",       Array(intStateReadConst)),  _
                                   Array("[0-9-]",      Array(intStateReadNumber)), _
                                   Array("""",          Array(intStateReadString)), _
                                   Array("\[",          Array(intStateReadArray)),  _
                                   Array("\]",          Array(intStateArrayRead)),  _
                                   Array("\{",          Array(intStateReadObject)), _
                                   Array("\}",          Array(intStateObjectRead))  _
                                  )

    arrStateArrayRead      = Array("", _
                                   Array(",",           Array(intContextLookup)),  _
                                   Array("\]",          Array(intStateArrayRead)), _
                                   Array("\}",          Array(intStateObjectRead)) _
                                  )

    arrStateReadObject     = Array("", _
                                   Array("""",          Array(intStateReadKey)),   _
                                   Array("\}",          Array(intStateObjectRead)) _
                                  )

    arrStateObjectRead     = Array("", _
                                   Array(",",           Array(intContextLookup)),  _
                                   Array("\]",          Array(intStateArrayRead)), _
                                   Array("\}",          Array(intStateObjectRead)) _
                                  )

    arrStateTable          = Array(arrStateAwaitKey,       _
                                   arrStateReadKey,        _
                                   arrStateKeyRead,        _
                                   arrStateAwaitValue,     _
                                   arrStateReadConst,      _
                                   arrStateConstRead,      _
                                   arrStateReadNumber,     _
                                   arrStateNumberRead,     _
                                   arrStateReadString,     _
                                   arrStateReadEscapeChar, _
                                   arrStateStringRead,     _
                                   arrStateReadArray,      _
                                   arrStateArrayRead,      _
                                   arrStateReadObject,     _
                                   arrStateObjectRead      _
                                  )
  End Sub


  '----------------------------------------------------------------------------
  'Destructor
  '----------------------------------------------------------------------------
  Private Sub Class_Terminate()
    Clear
    Set objFSO      = Nothing
    Set dicJsonFile = Nothing
  End Sub


  '----------------------------------------------------------------------------
  'Clear data model
  '----------------------------------------------------------------------------
  Private Sub Clear
    dicJsonFile.RemoveAll

    Set varCurDataStore = dicJsonFile
    intState            = intStateAwaitValue
    intLCnt             = 0
    strItem             = ""
    strKey              = ""
  End Sub


  '----------------------------------------------------------------------------
  'Get dictionary representing the root level of the JSON file data
  '----------------------------------------------------------------------------
  Public Property Get Content
    If IsObject(dicJsonFile.Item("")) Then
      Set Content = dicJsonFile.Item("")
    ElseIf IsArray(dicJsonFile.Item("")) Then
      Content = dicJsonFile.Item("")
    Else
      Content = NULL
    End If
  End Property


  '----------------------------------------------------------------------------
  'Get/Set EOL style for JSON data output
  '----------------------------------------------------------------------------
  Public Property Get EolStyle
    EolStyle = intEolStyle
  End Property


  Public Property Let EolStyle(intValue)
    intEolStyle = intValue
  End Property


  '----------------------------------------------------------------------------
  'Get/Set bracket style for JSON data output
  '----------------------------------------------------------------------------
  Public Property Get BracketStyle
    BracketStyle = intBracketStyle
  End Property


  Public Property Let BracketStyle(intValue)
    intBracketStyle = intValue
  End Property


  '----------------------------------------------------------------------------
  'Get/Set indent style for JSON data output
  '----------------------------------------------------------------------------
  Public Property Get IndentStyle
    IndentStyle = intIndentStyle
  End Property


  Public Property Let IndentStyle(intValue)
    intIndentStyle = intValue
  End Property


  '----------------------------------------------------------------------------
  'Get/Set indentation for JSON data output
  '----------------------------------------------------------------------------
  Public Property Get Indent
    Indent = intIndent
  End Property


  Public Property Let Indent(intValue)
    intIndent = intValue
  End Property


  '----------------------------------------------------------------------------
  'Get/Set if all values are strings on JSON data output
  '----------------------------------------------------------------------------
  Public Property Get AllStrValues
    AllStrValues = bolAllStrValues
  End Property


  Public Property Let AllStrValues(bolValue)
    bolAllStrValues = bolValue
  End Property


  '----------------------------------------------------------------------------
  'Get formatted JSON data
  '----------------------------------------------------------------------------
  Public Function ToString(bolClean)
    Dim strKey

    If dicJsonFile.Count > 0 Then
      ToString = PrintJsonDic(dicJsonFile, "", bolClean)
    Else
      ToString = ""
    End If
  End Function


  '----------------------------------------------------------------------------
  'Save formatted JSON data to a file
  '----------------------------------------------------------------------------
  Public Sub SaveToFile(ByRef strFilePath, intEncoding)
    Dim objOutStream

    Set objOutStream = objFSO.OpenTextFile(strFilePath, 2, True, intEncoding)
    objOutStream.Write ToString(True)
    objOutStream.Close
  End Sub


  '----------------------------------------------------------------------------
  'Load a JSON string and parse the data structure
  '----------------------------------------------------------------------------
  Public Function LoadFromString(ByRef strJsonString)
    Dim arrJsonString, intIdx

    Clear

    If strJsonString = "" Then
      LoadFromString = False
      Exit Function
    End If

    arrJsonString = Split(strJsonString, EolStr())

    For intIdx = 0 To UBound(arrJsonString)
      intLCnt = intLCnt + 1
      If Not ParseLine(arrJsonString(intIdx)) Then Exit For
    Next

    LoadFromString = (intState = intStateObjectRead Or intState = intStateArrayRead) And _
                     intStackPtr = -1
  End Function


  '----------------------------------------------------------------------------
  'Load a JSON file and parse the data structure
  '----------------------------------------------------------------------------
  Public Function LoadFromFile(ByRef strFilePath, intEncoding)
    Dim objInStream

    Clear

    If Not objFSO.FileExists(strFilePath) Then
      LoadFromFile = False
      Exit Function
    End If

    Set objInStream = objFSO.OpenTextFile(strFilePath, 1, False, intEncoding)

    Do While Not objInStream.AtEndOfStream
      intLCnt = intLCnt + 1
      If Not ParseLine(objInStream.ReadLine) Then Exit Do
    Loop

    objInStream.Close

    LoadFromFile = (intState = intStateObjectRead Or intState = intStateArrayRead) And _
                   intStackPtr = -1
  End Function


  '----------------------------------------------------------------------------
  'Parse JSON data from a string and create a data model
  '----------------------------------------------------------------------------
  Private Function ParseLine(ByRef strLine)
    Dim intLineLen, intCCnt, strChar
    Dim arrStateData, intCnt, intStateCnt
    Dim strCheck, intNewState
    Dim varParentDataStore

    intLineLen = Len(strLine)

    For intCCnt = 1 To intLineLen
      strChar      = Mid(strLine, intCCnt, 1)
      arrStateData = arrStateTable(intState)

      If strChar <> vbTab Then
        If strChar <> " " Or intState = intStateReadKey Or intState = intStateReadString Then
          DebugOutput 1, strLine, strChar, intState

          For intCnt = 1 To UBound(arrStateData)
            objRegEx.Pattern = arrStateData(intCnt)(0)
            If objRegEx.Test(strChar) Then Exit For
          Next

          If intCnt <= UBound(arrStateData) Then
            For intStateCnt = 0 To UBound(arrStateData(intCnt)(1))
              intNewState = arrStateData(intCnt)(1)(intStateCnt)

              If intNewState = intContextLookup Then
                intNewState = AwaitStateByContext(varCurDataStore)
              End If

              Select Case intNewState
                Case intStateReadKey
                  If intNewState = intState Then
                    strItem = strItem & strChar
                  End If

                Case intStateReadConst, _
                     intStateReadNumber
                  strItem  = strItem & strChar

                Case intStateReadString
                  If intNewState = intState Or _
                     intState    = intStateReadEscapeChar Then
                    strItem = strItem & strChar
                  End If

                Case intStateReadEscapeChar
                  strItem  = strItem & strChar

                Case intStateReadArray
                  Call StackPush(strKey, varCurDataStore)

                  varCurDataStore = Array()
                  strKey          = ""

                Case intStateReadObject
                  Call StackPush(strKey, varCurDataStore)

                  Set varCurDataStore         = CreateObject("Scripting.Dictionary")
                  varCurDataStore.CompareMode = vbTextCompare
                  strKey                      = ""

                Case intStateKeyRead, _
                     intStateConstRead, _
                     intStateNumberRead, _
                     intStateStringRead
                  strCheck = arrStateData(0)

                  If strCheck <> "" Then
                    objRegEx.Pattern = strCheck

                    If Not objRegEx.Test(strItem) Then
                      DebugOutput 2, strLine, strChar, intNewState
                      intNewState = intStateError
                    End If
                  End If

                  Select Case intNewState
                    Case intStateKeyRead
                      If strItem <> "" Then
                        strKey  = strItem
                        strItem = ""
                      Else
                        DebugOutput 3, strLine, strChar, intNewState
                        intNewState = intStateError
                      End If

                    Case intStateConstRead, _
                         intStateNumberRead, _
                         intStateStringRead
                      If strKey <> "" Or IsArrayContext(varCurDataStore) Then
                        If StoreData(varCurDataStore, strKey, strItem) Then
                          strKey  = ""
                          strItem = ""

                        Else
                          DebugOutput 4, strLine, strChar, intNewState
                          intNewState = intStateError
                        End If
                      Else
                        DebugOutput 5, strLine, strChar, intNewState
                        intNewState = intStateError
                      End If
                  End Select

                Case intStateArrayRead, _
                     intStateObjectRead
                  If intStackPtr >= 0 Then
                    Call StackPop(strKey, varParentDataStore)

                    If strKey <> "" Or IsArrayContext(varParentDataStore) _
                                    Or IsSameObject(varParentDataStore, dicJsonFile) Then
                      If StoreData(varParentDataStore, strKey, varCurDataStore) Then
                        If IsObject(varParentDataStore) Then
                          Set varCurDataStore = varParentDataStore
                        Else
                          varCurDataStore = varParentDataStore
                        End If

                        strKey  = ""
                        strItem = ""
                      Else
                        DebugOutput 6, strLine, strChar, intNewState
                        intNewState = intStateError
                      End If
                    End If
                  Else
                    DebugOutput 7, strLine, strChar, intNewState
                    intNewState = intStateError
                  End If
              End Select

              DebugOutput 8, strLine, strChar, intNewState
            Next
          Else
            DebugOutput 9, strLine, strChar, intNewState
            intNewState = intStateError
          End If

          intState = intNewState

          If intState = intStateError Then
            PrintErrorMessage intLCnt, intCCnt
            Exit For
          End If
        End If
      End If
    Next

    ParseLine = (intState <> intStateError)
  End Function


  '----------------------------------------------------------------------------
  'Store data
  '----------------------------------------------------------------------------
  Private Function StoreData(ByRef varDataStore, ByRef varKey, ByRef varValue)
    StoreData = False

    If IsObject(varDataStore) Then
      If Not varDataStore.Exists(varKey) Then
        If intDebugLevel > 0 then
          If IsObject(varValue) Then
            WScript.Echo "Add to Object: " & varKey & "=Object" & vbNewLine
          ElseIf IsArray(varValue) Then
            WScript.Echo "Add to Object: " & varKey & "=Array" & vbNewLine
          Else
            WScript.Echo "Add to Object: " & varKey & "=" & varValue & vbNewLine
          End If
        End If

        Call varDataStore.Add(varKey, varValue)
        StoreData = True
      End If

    ElseIf IsArray(varDataStore) Then
      ReDim Preserve varDataStore(UBound(varDataStore) + 1)

      If intDebugLevel > 0 then
        If IsObject(varValue) Then
          WScript.Echo "Add to Array[" & UBound(varDataStore) & "]: Object" & vbNewLine
        ElseIf IsArray(varValue) Then
          WScript.Echo "Add to Array[" & UBound(varDataStore) & "]: Array" & vbNewLine
        Else
          WScript.Echo "Add to Array[" & UBound(varDataStore) & "]: " & varValue & vbNewLine
        End If
      End If

      If IsObject(varValue) Then
        Set varDataStore(UBound(varDataStore)) = varValue
      Else
        varDataStore(UBound(varDataStore)) = varValue
      End If

      StoreData = True
    End If
  End Function


  '----------------------------------------------------------------------------
  'Push key name and parent data store
  '----------------------------------------------------------------------------
  Private Sub StackPush(ByRef strName, ByRef varDataStore)
    intStackPtr = intStackPtr + 1

    ReDim Preserve arrStack(intStackPtr)
    arrStack(intStackPtr) = Array("", NULL)

    If IsObject(varDataStore) Then
      If intDebugLevel > 0 Then
        WScript.Echo "Push Name: " & strName
        WScript.Echo "Push Parent DataStore: Object" & vbNewLine
      End If

      arrStack(intStackPtr)(0)     = strName
      Set arrStack(intStackPtr)(1) = varDataStore

    ElseIf IsArray(varDataStore) Then
      If intDebugLevel > 0 Then
        WScript.Echo "Push Name: " & strName
        WScript.Echo "Push Parent DataStore: Array" & vbNewLine
      End If

      arrStack(intStackPtr)(0) = strName
      arrStack(intStackPtr)(1) = varDataStore
    End If
  End Sub


  '----------------------------------------------------------------------------
  'Pop key name and parent data store
  '----------------------------------------------------------------------------
  Private Sub StackPop(ByRef strName, ByRef varDataStore)
    If intStackPtr >= 0 Then
      strName = arrStack(intStackPtr)(0)

      If IsObject(arrStack(intStackPtr)(1)) Then
        If intDebugLevel > 0 Then
          WScript.Echo "Pop Name: " & strName
          WScript.Echo "Pop Parent DataStore: Object" & vbNewLine
        End If

        Set varDataStore = arrStack(intStackPtr)(1)

      ElseIf IsArray(arrStack(intStackPtr)(1)) Then
        If intDebugLevel > 0 Then
          WScript.Echo "Pop Name: " & strName
          WScript.Echo "Pop Parent DataStore: Array" & vbNewLine
        End If

        varDataStore = arrStack(intStackPtr)(1)
      End If

      intStackPtr = intStackPtr - 1
    Else
      strName      = NULL
      varDataStore = NULL
    End If
  End Sub


  '----------------------------------------------------------------------------
  'Check if next item has to be a key or a value
  '----------------------------------------------------------------------------
  Private Function AwaitStateByContext(ByRef varDataStore)
    If IsArrayContext(varDataStore) Then
      AwaitStateByContext = intStateAwaitValue
    Else
      AwaitStateByContext = intStateAwaitKey
    End If
  End Function


  '----------------------------------------------------------------------------
  'Check if provided data store is an array
  '----------------------------------------------------------------------------
  Private Function IsArrayContext(ByRef varDataStore)
    IsArrayContext = IsArray(varDataStore)
  End Function


  '----------------------------------------------------------------------------
  'Check if two object references refer the same object
  '----------------------------------------------------------------------------
  Private Function IsSameObject(varObj1, varObj2)
    If IsObject(varObj1) And IsObject(varObj2) Then
      IsSameObject = (varObj1 Is varObj2)
    Else
      IsSameObject = False
    End If
  End Function


  '----------------------------------------------------------------------------
  'Convert JSON object to formatted text
  '----------------------------------------------------------------------------
  Private Function PrintJsonDic(ByRef dicDataStore, strIndent, bolClean)
    Dim strKey, varValue, strLine

    strLine = ""

    For Each strKey In dicDataStore.Keys
      If strLine <> "" Then
        strLine = strLine & "," & EolStr()
      End If

      If IsObject(dicDataStore.Item(strKey)) Then
        Set varValue = dicDataStore.Item(strKey)
      Else
        varValue = dicDataStore.Item(strKey)
      End If

      If IsObject(varValue) Then
        Select Case intBracketStyle
          Case BracketStyleAllman:
            If strKey <> "" Then
              strLine = strLine & strIndent & """" & strKey & """:" & EolStr()
            End If

            strLine = strLine & strIndent & "{" & EolStr() & _
                                PrintJsonDic(varValue, strIndent & IndentStr(), bolClean) & _
                                strIndent & "}"

          Case Else  'BracketStyleJava:
            If strKey <> "" Then
              strLine = strLine & strIndent & """" & strKey & """: {" & EolStr()
            Else
              strLine = strLine & strIndent & "{" & EolStr()
            End If

            strLine = strLine & PrintJsonDic(varValue, strIndent & IndentStr(), bolClean) & _
                                strIndent & "}"
        End Select

      ElseIf IsArray(varValue) Then
        Select Case intBracketStyle
          Case BracketStyleAllman:
            If strKey <> "" Then
              strLine = strLine & strIndent & """" & strKey & """: " & EolStr()
            Else
              strLine = ""
            End If

            strLine = strLine & strIndent & "[" & EolStr() & _
                                PrintJsonArr(varValue, strIndent & IndentStr(), bolClean) & _
                                strIndent & "]"

          Case Else  'BracketStyleJava:
            If strKey <> "" Then
              strLine = strLine & strIndent & """" & strKey & """: [" & EolStr()
            Else
              strLine = strLine & strIndent & "[" & EolStr()
            End If

            strLine = strLine & PrintJsonArr(varValue, strIndent & IndentStr(), bolClean) & _
                                strIndent & "]"
        End Select

      ElseIf IsNumeric(varValue) And Not bolAllStrValues Then
        strLine = strLine & strIndent & """" & strKey & """: " & varValue

      ElseIf LCase(varValue) = "null"  Or _
             LCase(varValue) = "true"  Or _
             LCase(varValue) = "false" Then
        strLine = strLine & strIndent & """" & strKey & """: " & varValue

      Else
        strLine = strLine & strIndent & """" & strKey & """" & ": """ & varValue & """"
      End If
    Next

    If strLine <> "" Then strLine = strLine & EolStr()

    PrintJsonDic = strLine
  End Function


  '----------------------------------------------------------------------------
  'Convert JSON array to formatted text
  '----------------------------------------------------------------------------
  Private Function PrintJsonArr(ByRef arrDataStore, strIndent, bolClean)
    Dim intCnt, varValue, strLine
    Dim intLocalIndentLen, strLocalIndent

    intCnt  = 0
    strLine = ""

    intLocalIndentLen = Len(CStr(UBound(arrDataStore))) + 4

    If Not bolClean Then
      strLocalIndent  = String(intLocalIndentLen, " ")
    Else
      strLocalIndent  = ""
    End If

    For Each varValue In arrDataStore
      If strLine <> "" Then
        strLine = strLine & "," & EolStr()
      End If

      If IsObject(varValue) Then
        strLine = strLine & strIndent & JsonArrPrefix(bolClean, intLocalIndentLen, intCnt) & "{" & EolStr() & _
                            PrintJsonDic(varValue, strIndent & strLocalIndent & IndentStr(), bolClean) & _
                            strIndent & strLocalIndent & "}"

      ElseIf IsArray(varValue) Then
        strLine = strLine & strIndent & JsonArrPrefix(bolClean, intLocalIndentLen, intCnt) & "[" & EolStr() & _
                            PrintJsonArr(varValue, strIndent & strLocalIndent & IndentStr(), bolClean) & _
                            strIndent & strLocalIndent & "]"

      ElseIf IsNumeric(varValue) And Not bolAllStrValues Then
        strLine = strLine & strIndent & JsonArrPrefix(bolClean, intLocalIndentLen, intCnt) & varValue

      ElseIf LCase(varValue) = "null"  Or _
             LCase(varValue) = "true"  Or _
             LCase(varValue) = "false" Then
        strLine = strLine & strIndent & JsonArrPrefix(bolClean, intLocalIndentLen, intCnt) & varValue

      Else
        strLine = strLine & strIndent & JsonArrPrefix(bolClean, intLocalIndentLen, intCnt) & """" & varValue & """"
      End If

      intCnt = intCnt + 1
    Next

    If strLine <> "" Then strLine = strLine & EolStr()

    PrintJsonArr = strLine
  End Function


  '----------------------------------------------------------------------------
  'Create EOL string according to current EOL style
  '----------------------------------------------------------------------------
  Private Function EolStr()
    Select Case intEolStyle
      Case EolStyleWindows
        EolStr = vbCrLf

      Case Else  'EolStyleUnix
        EolStr = vbLf
    End Select
  End Function


  '----------------------------------------------------------------------------
  'Create indentation string according to current indentation style
  '----------------------------------------------------------------------------
  Private Function IndentStr()
    Select Case intIndentStyle
      Case IndentStyleSpace
        IndentStr = String(intIndent, " ")

      Case Else  'IndentStyleTab
        IndentStr = String(intIndent, vbTab)
    End Select
  End Function


  '----------------------------------------------------------------------------
  'Create index of JSON array item for its text representation
  '----------------------------------------------------------------------------
  Private Function JsonArrPrefix(bolClean, intBasePadding, intCnt)
    If Not bolClean Then
      JsonArrPrefix = "[" & intCnt & "]:" & String(intBasePadding - 3 - Len(CStr(intCnt)), " ")
    Else
      JsonArrPrefix = ""
    End If
  End Function


  '----------------------------------------------------------------------------
  'Output error message including number of failed line and character
  '----------------------------------------------------------------------------
  Private Sub PrintErrorMessage(intLCnt, intCCnt)
    WScript.Echo "Error in line " & intLCnt & ", character " & intCCnt
  End Sub


  '----------------------------------------------------------------------------
  'Output debug infos
  '----------------------------------------------------------------------------
  Private Sub DebugOutput(intId, ByRef strLine, strChar, intState)
    If intDebugLevel > 1 Then
      WScript.Echo intId
      WScript.Echo "Line:  " & strLine
      WScript.Echo "Char:  " & strChar
      WScript.Echo "State: " & intState
      WScript.Echo
    End If
  End Sub
End Class
