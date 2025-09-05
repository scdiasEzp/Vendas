page 60103 ApiWarehouseShipmentLine
{
    PageType = API;
    APIPublisher = 'ezpeleta';
    APIGroup = 'sales';
    APIVersion = 'v2.0';
    EntityName = 'warehouseshipmentline';
    EntitySetName = 'warehouseshipmentline';
    SourceTable = "Warehouse Shipment Line";
    DelayedInsert = true;
    //SourceTableTemporary=true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(sourceNo; sourceNo)
                {
                    Caption = 'Source No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(qtyToShip; QtyToShip)
                {
                    Caption = 'Qty. to Ship';
                }
                field(sourceType; Rec."Source Type")
                {
                    Caption = 'Source Type';
                }
                field(sourceSubtype; Rec."Source Subtype")
                {
                    Caption = 'Source Subtype';
                }
                field(sourceLineNo; sourceLineNo)
                {
                    Caption = 'Source Line No.';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        setupNewLine();
        exit(false);
    end;

    trigger OnAfterGetRecord()
    begin
        sourceNo := Rec."Source No.";
        sourceLineNo := Rec."Source Line No.";
        QtyToShip := Rec."Qty. to Ship";
    end;

    var
        sourceNo: Code[20];
        sourceLineNo: Integer;
        QtyToShip: Decimal;

    local procedure setupNewLine()
    var
        SalesLine: Record "Sales Line";
        WhseCreateSourceDocument: Codeunit "Whse.-Create Source Document";
        GetSourceDocuments: Report "Get Source Documents";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        AlreadyExists: Label 'Record already exists';
    begin
        WarehouseShipmentHeader.Get(Rec."No.");
        SalesLine.Get("Sales Document Type"::Order, sourceNo, sourceLineNo);
        If FindWarehouseShipmentLine(SalesLine, WarehouseShipmentHeader) then
            Error(AlreadyExists);
        if not GetSourceDocuments.CreateActivityFromSalesLine2ShptLine(WarehouseShipmentHeader, SalesLine) then
            Error(GetLastErrorText);
        FindWarehouseShipmentLine(SalesLine, WarehouseShipmentHeader);
        Rec.Validate("Qty. to Ship", QtyToShip);
        Rec.Modify();
    end;

    local procedure FindWarehouseShipmentLine(var SalesLine: Record "Sales Line"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"): Boolean
    begin
        Rec.SetRange("No.", WarehouseShipmentHeader."No.");
        Rec.SetRange("Source No.", salesline."Document No.");
        Rec.SetRange("Source Line No.", SalesLine."Line No.");
        exit(Rec.FindFirst());
    end;
}