package main

import (
	resources "github.com/pulumi/pulumi-azure-native/sdk/go/azure/resources"
	web "github.com/pulumi/pulumi-azure-native/sdk/go/azure/web"
	insights "github.com/pulumi/pulumi-azure-native/sdk/go/azure/insights"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		conf := config.New(ctx, "")
        location := conf.Require("location")
		rgName := conf.Require("rgName")
		appServicePlanName := conf.Require("appServicePlanName")
		appServiceName := conf.Require("appServiceName")
		appInsightsName := conf.Require("appInsightsName")

		resourceGroup, err := resources.NewResourceGroup(ctx, "resourceGroup", &resources.ResourceGroupArgs{
			Location: pulumi.String(location),
			ResourceGroupName: pulumi.String(rgName),
		})
		if err != nil {
			return err
		}


		appInsights, err := insights.NewComponent(ctx, "Insights", &insights.ComponentArgs{
			ResourceName: pulumi.String(appInsightsName),
			Location: pulumi.String(location), 
			Kind: pulumi.String("other"),
			ResourceGroupName: resourceGroup.Name,
			ApplicationType: pulumi.String("other"),
		})
		if err != nil {
			return err
		}

		asp, err := web.NewAppServicePlan(ctx, "appServicePlan", &web.AppServicePlanArgs{
			Location: pulumi.String(location),
			ResourceGroupName: resourceGroup.Name,
			Name: pulumi.String(appServicePlanName),
			Kind: pulumi.String("Linux"),
			Reserved: pulumi.Bool(true),
			Sku: &web.SkuDescriptionArgs{
				Capacity: pulumi.Int(1),
				Size: pulumi.String("F1"),
				Name: pulumi.String("F1"),
				Tier: pulumi.String("Free"),
			},
		})
		if err != nil {
			return err
		}
		_, err = web.NewWebApp(ctx, "AppService", &web.WebAppArgs{
			Name: pulumi.String(appServiceName),
			Location: pulumi.String(location),
			ResourceGroupName: resourceGroup.Name,
			ServerFarmId: asp.ID(),
			SiteConfig: &web.SiteConfigArgs{
				LinuxFxVersion: pulumi.String("PYTHON|3.9"),
				Use32BitWorkerProcess: pulumi.Bool(true),
				AppSettings: web.NameValuePairArray{
					&web.NameValuePairArgs{
						Name: pulumi.String("APPINSIGHTS_INSTRUMENTATIONKEY"),
						Value: appInsights.InstrumentationKey,
					},
				},
			},
		})
		if err != nil {
			return err
		}		


		return nil
	})
}
