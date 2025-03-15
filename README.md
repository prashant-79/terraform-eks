# springboot-common-infrastructure
springboot-common-infrastructure

Repository Structure
1. VPC
2. ACM
3. EKS
4. ALB
    So that same ALB we can use for pur project and can be used for monitoring tools and other application services as well
4. Monitoring
    - Prometheus
    - Grafana
    - Alert Manager
    - ALB Configuration
        - Annotation to ensure create LB with the name provided
        - For SSL redirect
        - ACM Certificate applied to load balancer


## Best Practices
1. Terraform provider version lock
2. Provider level tagging
3. Resources Naming Convention

## Github Workflows
1. PR workflow
2. CD workflow
3. Auto detect trigger which folder has changed


## Issues
   ingress  Failed deploy model due to operation error Elastic Load Balancing v2: CreateLoadBalancer, https response error StatusCode: 400, RequestID: f7b233cd-2822-4396-a539-7db524243ef8, DuplicateLoadBalancerName: A load balancer with the same name 'dev-alb' exists, but with different settings
Troubleshoot
kubectl logs -n kube-system <ingress-controller-pod>
