/// <summary>
/// This PageExtension adds an action to the Customer List page to perform a high performance posting test. It posts 5000 lines to a specified G/L account and then posts a balancing line to another G/L account. The elapsed time for the posting process is displayed in a message box.
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
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Performs a high performance posting test by posting 5000 lines to a specified G/L account and then posting a balancing line to another G/L account. The elapsed time for the posting process is displayed in a message box.';
                trigger OnAction()
                var
                    glPost: Codeunit "Gen. Jnl.-Post Line";
                    startTime: DateTime;
                    bal: Decimal;
                    bal2: Decimal;
                    i: Integer;
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

    procedure PostLine(var GLPost: Codeunit "Gen. Jnl.-Post Line"; Acc: Code[20]; DocNo: Code[20]; Amount: Decimal)
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
        GenJnlLine.Amount := Amount;
        GLPost.RunWithoutCheck(GenJnlLine);
    end;
}
