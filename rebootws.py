import boto3
import getpass

def find_workspace_id(region, username):
    client = boto3.client('workspaces', region_name=region)
    paginator = client.get_paginator('describe_workspaces')
    for response in paginator.paginate():
        for workspace in response['Workspaces']:
            if workspace['UserName'] == username:
                return workspace['WorkspaceId']
    return None

def reboot_workspace(region, workspace_id):
    client = boto3.client('workspaces', region_name=region)
    response = client.reboot_workspaces(
        RebootWorkspaceRequests=[
            {
                'WorkspaceId': workspace_id
            },
        ]
    )
    return response

def main():
    username = input('Enter the username: ')
    workspace_id = find_workspace_id('us-west-2', username)
    region = 'us-west-2'
    if workspace_id is None:
        workspace_id = find_workspace_id('ap-south-1', username)
        region = 'ap-south-1'
    if workspace_id is None:
        print('No workspace found for user', username)
        return
    print('Username:', username)
    print('WorkspaceID:', workspace_id)
    print('Region:', region)
    confirm = input('Do you want to reboot this workspace? (y/n) ')
    if confirm.lower() == 'y':
        response = reboot_workspace(region, workspace_id)
        print('Reboot request sent. Response:', response)

if __name__ == '__main__':
    main()
