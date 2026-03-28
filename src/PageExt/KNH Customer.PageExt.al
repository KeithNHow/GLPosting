/// <summary>
/// This PageExtension adds an action to the Customer List page to perform a high performance posting test. It posts 5000 lines to a specified G/L account and then posts a balancing line to another G/L account. The elapsed time for the posting process is displayed in a message box.
/// </summary>
namespace KNHGLPosting;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50800 "KNH Customer" extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(TestGJLPost)
            {
                Caption = 'Test GJL Post';
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Performs a high performance posting test by posting 5000 lines to a specified G/L account and then posting a balancing line to another G/L account. The elapsed time for the posting process is displayed in a message box.';
                trigger OnAction()
                var
                    GLPost: Codeunit "Gen. Jnl.-Post Line";
                    StartTime: DateTime;
                    Duration: Duration;
                    I: Integer;
                begin
                    StartTime := CurrentDateTime();
                    for I := 1 to 5000 do begin
                        PostLine(GLPost, '5110', 'Doc0001', 0.01, I);
                    end;
                    PostLine(GLPost, '8110', 'Doc0001', -0.01, I);
                    Duration := CurrentDateTime - StartTime;
                    Message('Elapsed Time = %1', Duration)
                end;
            }
        }
    }

    procedure PostLine(var GLPost: Codeunit "Gen. Jnl.-Post Line"; Acc: Code[20]; DocNo: Code[20]; Amount: Decimal; I: Integer)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init();
        GenJnlLine."Posting Date" := Today();
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := Acc;
        GenJnlLine.Description := 'Test Posting Line ' + Format(I);
        GenJnlLine.Amount := Amount;
        GLPost.RunWithoutCheck(GenJnlLine);
    end;
}
