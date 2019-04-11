#!/bin/bash
delete_igws(){
	echo -e "\033[0;33m\tInternetGateways:\033[0m"
	vpcregion=$1
	vpcid=$2
	igw_id=`aws ec2 describe-internet-gateways --region ${vpcregion} --query "InternetGateways[?Attachments[?VpcId=='${vpcid}']].InternetGatewayId" --output text 2>/dev/null`
	if [ "${igw_id}" ]; then
		echo -e "\tInternet Gateway Id in region ${vpcregion} for vpc ${vpcid}: ${igw_id}";
		aws ec2 detach-internet-gateway --region ${vpcregion} --internet-gateway-id ${igw_id} --vpc-id ${vpcid}
		echo -e "\tDetached internet-gateway ${igw_id} vpc-id ${vpcid}"
		aws ec2 delete-internet-gateway --region ${vpcregion} --internet-gateway-id ${igw_id}
		echo -e "\tDeleted internet-gateway"
	else
		echo -e "\tNo Internet Gateway found in region ${vpcregion} for vpc ${vpcid}";
	fi
}

delete_subnets(){
	echo -e "\033[0;33m\tSubnets:\033[0m"
	vpcregion=$1
	vpcid=$2
	aws ec2 describe-subnets --region ${vpcregion} --query "Subnets[?VpcId=='${vpcid}'].SubnetId" --output text | xargs -n 1 2>/dev/null > subnets.list
	if [ `wc -l subnets.list | awk '{print $1}'` > 0 ]; then
		for subnet_id in `cat subnets.list`;
			do
				echo -e "\tDeleting subnet ${subnet_id}"
				aws ec2 delete-subnet  --region ${vpcregion} --subnet-id ${subnet_id};
			done
		else
			echo -e "\t\tNo Subnets found in region ${vpcregion} for vpc ${vpcid}"
	fi
	rm subnets.list
}

delete_routetables(){
	echo -e "\033[0;33m\tRouteTables:\033[0m"
	vpcregion=$1
	vpcid=$2
	aws ec2 describe-route-tables --region ${vpcregion} --query "RouteTables[?VpcId=='${vpcid}'].RouteTableId" --output text 2>/dev/null > routetables.list
	if [ `wc -l routetables.list | awk '{print $1}'` > 0 ]; then
		for routetable_id in `cat routetables.list`;
			do
				echo -e "\t\tDeleting route-table ${routetable_id}";
				aws ec2 delete-route-table  --region ${vpcregion} --route-table-id ${routetable_id}
			done
		else
			echo -e "\t\tNo route table exists"
	fi
	rm routetables.list
}

delete_nacls(){
	echo -e "\033[0;33m\tNetworkAcls:\033[0m"
	vpcregion=$1
	vpcid=$2
	aws ec2 describe-network-acls --region ${vpcregion} --query "NetworkAcls[?VpcId=='${vpcid}'].NetworkAclId" --output text 2>/dev/null > nacls.list
	if [ `wc -l nacls.list | awk '{print $1}'` > 0 ]; then
		for nacl_id in `cat nacls.list`;
			do
				echo -e "\tDeleting route-table ${nacl_id}";
				aws ec2 delete-network-acl --region ${vpcregion} --network-acl-id ${nacl_id}
			done
		else
			echo -e "\tNo NACL exists"
	fi
	rm nacls.list
}
delete_securitygroups(){
	echo -e "\033[0;33m\tSecurityGroups:\033[0m"
	vpcregion=$1cat
	vpcid=$2
	aws ec2 describe-security-groups --region ${vpcregion} --query "SecurityGroups[?VpcId=='${vpcid}'].GroupName" --output text 2>/dev/null > secgroups.list
	if [ `wc -l secgroups.list | awk '{print $1}'` > 0 ]; then
		for security_grp in `cat secgroups.list`;
			do
				echo -e "\tDeleting SecurityGroup ${security_grp}";
				aws ec2 delete-security-group  --region ${vpcregion} --group-name ${security_grp}
			done
		else
			echo -e "\tNo SecurityGroup exists"
	fi
	rm secgroups.list
}
delete_vpcs(){
	echo -e "\033[0;33m\tDefault Vpcs:\033[0m"
	vpcregion=$1
	vpcid=$2
	aws ec2 delete-vpc --region ${vpcregion} --vpc-id ${vpcid}
	echo -e "\033[0;32m\tSuccessfully Deleted VPCs\033[0m"
}
rm default-vpcs.list 2>/dev/null
touch default-vpcs.list
echo "Please wait while the list is being gathered."
for region in `aws ec2 describe-regions --query "Regions[].RegionName" --output text | xargs -n 1`;
	do
		echo "${region} `aws ec2 describe-vpcs --region ${region} --query 'Vpcs[*].{vpdId:VpcId,defaultVpc:IsDefault}' --output text | grep True`" | grep True | awk '{print $1":"$3}'>>default-vpcs.list;
	done
if [ -f default-vpcs.list ] && [ `wc -l default-vpcs.list | awk '{print $1}'` -gt 0 ]; then
	echo "List of default VPCs to be deleted `wc -l default-vpcs.list | awk '{print $1}'`";
	for vpc_detail in `cat default-vpcs.list`;
		do
			vpc_region=`echo ${vpc_detail}|awk -F":" '{print $1}'`;
			vpc_id=`echo ${vpc_detail}|awk -F":" '{print $2}'`;
			echo "vpc_region=$vpc_region and vpc_id=$vpc_id";
			delete_igws ${vpc_region} ${vpc_id}
			delete_subnets ${vpc_region} ${vpc_id}
			delete_securitygroups ${vpc_region} ${vpc_id}
			delete_vpcs ${vpc_region} ${vpc_id}
			delete_routetables ${vpc_region} ${vpc_id}
			delete_nacls ${vpc_region} ${vpc_id}
		done
else
	echo "No default VPCs in this account"
fi
