namespace Ezpeleta.Vendas;
using System.Text;
using Microsoft.Sales.History;
using Microsoft.Foundation.Reporting;
using System.Utilities;

page 60104 ApiSalesShipmentReport
{
    PageType = API;
    APIPublisher = 'ezpeleta';
    APIGroup = 'sales';
    APIVersion = 'v2.0';
    EntityName = 'SalesShipmentReport';
    EntitySetName = 'SalesShipmentReport';
    SourceTable = "Sales Shipment Header";
    // SourceTableTemporary = true;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; Rec."No.")
                {
                }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                }
                field(orderNo; Rec."Order No.")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(SalesShipmentReportBase64; SalesShipmentReportBase64)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        NoFilters: Label 'Records has no filters';
    begin
        if Rec.GetFilters() = '' then
            Error(NoFilters);
    end;

    trigger OnAfterGetRecord()
    var
        SalesPostSubs: Codeunit SalesPostSubs;
        ReportSelections: Record "Report Selections";
        InStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
    begin
        ReportSelections.SetRange(Usage, "Report Selection Usage"::"S.Shipment");
        ReportSelections.FindFirst();
        SalesPostSubs.GetReportLayout(InStream, TempBlob, ReportSelections."Report ID", Rec.RecordId, '', ReportFormat::Pdf);
        SalesShipmentReportBase64 := Base64Convert.ToBase64(InStream);
    end;

    // [ServiceEnabled]
    // procedure print(filterRecNo: Text)
    // var
    //     SalesPostSubs: Codeunit SalesPostSubs;
    //     ReportSelections: Record "Report Selections";
    //     InStream: InStream;
    //     TempBlob: Codeunit "Temp Blob";
    //     Base64Convert: Codeunit "Base64 Convert";
    // begin
    //     ReportSelections.SetRange(Usage, "Report Selection Usage"::"S.Shipment");
    //     ReportSelections.FindFirst();
    //     Rec.SetFilter("No.", filterRecNo);
    //     SalesPostSubs.GetReportLayout(InStream, TempBlob, ReportSelections."Report ID", Rec.RecordId, Rec.GetView(), ReportFormat::Pdf);
    //     SalesShipmentReportBase64 := Base64Convert.ToBase64(InStream);
    // end;

    var
        SalesShipmentReportBase64: Text;
}