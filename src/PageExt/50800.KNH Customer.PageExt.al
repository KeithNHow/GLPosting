/// <summary>
/// PageExtension KNH Customer (ID 50800) extends Record Customer Card.
/// </summary>
pageextension 50800 "KNH Customer" extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(HPPost)
            {
                Caption = 'HP Posting';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    glPost: Codeunit "Gen. Jnl.-Post Line";
                    i: Integer;
                    bal: Decimal;
                    bal2: Decimal;
                    startTime: DateTime;
                begin
                    startTime := CurrentDateTime();
                    for i := 1 to 5000 do begin
                        bal += i;
                        PostLine(glPost, '5110', 'Doc0001', bal);
                        bal2 += bal;
                    end;
                    PostLine(glPost, '8110', 'Doc0001', -bal2);
                    Message('Elapsed %1', CurrentDateTime - startTime)
                end;
            }
        }
    }

    /// <summary>
    /// PostLine.
    /// </summary>
    /// <param name="GLPost">VAR Codeunit "Gen. jnl.-post Line".</param>
    /// <param name="Acc">Code[20].</param>
    /// <param name="DocNo">Code[20].</param>
    /// <param name="Amount">Decimal.</param>
    procedure PostLine(var GLPost: Codeunit "Gen. jnl.-post Line"; Acc: Code[20]; DocNo: Code[20]; Amount: Decimal)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init();
        GenJnlLine."Posting Date" := Today();
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := Acc;
        GenJnlLine.Description := 'HP Posting';
        GenJnlLine."Amount" := Amount;
        GLPost.RunWithoutCheck(GenJnlLine);
    end;
}
