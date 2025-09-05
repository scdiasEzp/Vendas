namespace Ezpeleta.Vendas;
using Microsoft.Warehouse.History;
using Microsoft.Warehouse.Document;

page 60102 ApiWarehouseShipment
{
    PageType = API;
    APIPublisher = 'ezpeleta';
    APIGroup = 'sales';
    APIVersion = 'v2.0';
    EntityName = 'warehouseshipment';
    EntitySetName = 'warehouseshipment';
    SourceTable = "Warehouse Shipment Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(zoneCode; Rec."Zone Code")
                {
                    Caption = 'Zone Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(assignedUserID; Rec."Assigned User ID")
                {
                    Caption = 'Assigned User ID';
                }
            }
        }
    }

    [ServiceEnabled]
    procedure post(): Text
    var
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        WhseShptLine: Record "Warehouse Shipment Line";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesPostSubs: Codeunit SalesPostSubs;
    begin
        SalesPostSubs.SetFromAPIPostWarehouseShipment(true);
        WhseShptLine.SetRange("No.", Rec."No.");
        WhseShptLine.FindSet();

        WhsePostShipment.SetPostingSettings(false);
        WhsePostShipment.SetPrint(false);
        SafePostWhseShipment(WhsePostShipment, WhseShptLine);

        // PostedWhseShipmentLine.SetRange("Whse. Shipment No.", Rec."No.");
        // PostedWhseShipmentLine.FindLast();

        exit(SalesPostSubs.GetListOfSalesShipmentsAsText());
    end;

    [CommitBehavior(CommitBehavior::Ignore)]
    local procedure SafePostWhseShipment(var WhsePostShipment: Codeunit "Whse.-Post Shipment"; var WhseShptLine: Record "Warehouse Shipment Line")
    begin
        WhsePostShipment.Run(WhseShptLine);
    end;
}