codeunit 60100 SalesPostSubs
{
    SingleInstance = true;

    var
        ListOfSalesShipments: List of [Text];
        FromAPIPostWarehouseShipment: Boolean;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesShptHeaderInsert, '', false, false)]
    local procedure "Sales-Post_OnAfterSalesShptHeaderInsert"(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; SuppressCommit: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean)
    begin
        if SalesShipmentHeader.IsTemporary() or not FromAPIPostWarehouseShipment then
            exit;
        if ListOfSalesShipments.IndexOf(SalesShipmentHeader."No.") = 0 then
            ListOfSalesShipments.Add(SalesShipmentHeader."No.");
    end;

    procedure SetFromAPIPostWarehouseShipment(newFromAPIPostWarehouseShipment: Boolean)
    begin
        FromAPIPostWarehouseShipment := newFromAPIPostWarehouseShipment
    end;

    procedure GetFromAPIPostWarehouseShipment(): Boolean
    begin
        exit(FromAPIPostWarehouseShipment);
    end;

    procedure GetListOfSalesShipmentsAsText(): Text
    var
        item, SalesShipments : Text;
    begin
        foreach item in ListOfSalesShipments do begin
            if SalesShipments <> '' then
                SalesShipments += '|';
            SalesShipments += item;
        end;
        exit(SalesShipments);
    end;

    procedure GetReportLayout(var FileStream: InStream; var TempBlob: Codeunit "Temp Blob"; ReportId: Integer; RecId: RecordId; RecView: Text; RepoFormat: ReportFormat)
    var
        OutStr: OutStream;
        RecRef: RecordRef;
    begin
        if RecView = '' then begin
            RecRef.Get(RecId);
            RecRef.SetRecFilter();
        end
        else begin
            RecRef.Open(RecId.TableNo);
            RecRef.SetView(RecView);
        end;
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        Report.SaveAs(ReportId, '', RepoFormat, OutStr, RecRef);
        TempBlob.CreateInStream(FileStream);
    end;
}