.PHONY: apex-deploy apex-test apex-monitor apex-all apex-clean apex-status

# 🏛️ APEX NEXUS SUPREME - Master Makefile

## One-Command Deployment
apex-all: apex-deploy apex-monitor
	@echo ""
	@echo "🎉 APEX NEXUS SUPREME FULLY DEPLOYED!"
	@echo ""
	@python3 apex_deploy.py

## Deploy Architecture
apex-deploy:
	@echo "🚀 Deploying APEX Architecture..."
	@python3 apex_deploy.py

## Run Tests
apex-test:
	@echo "🧪 Testing APEX Integration..."
	@python3 -m pytest tests/ -v
	@echo ""
	@echo "✅ All tests passed!"

## Launch Monitoring
apex-monitor:
	@echo "📊 Launching Monitoring Stack..."
	@docker-compose -f docker-compose.apex.yml up -d
	@echo ""
	@echo "  • Grafana: http://localhost:3000 (admin/glaciereq2025)"
	@echo "  • Prometheus: http://localhost:9090"
	@echo "  • Neo4j: http://localhost:7474 (neo4j/glaciereq2025)"

## Check System Status
apex-status:
	@echo "📊 APEX System Status:"
	@echo ""
	@curl -s http://localhost:8000/api/v1/health | jq . || echo "⚠️  APEX API not responding"
	@echo ""
	@docker ps --filter "name=apex" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

## Clean Everything
apex-clean:
	@echo "🧽 Cleaning APEX deployment..."
	@docker-compose -f docker-compose.apex.yml down -v
	@docker rm -f apex-neo4j 2>/dev/null || true
	@docker volume rm apex_neo4j_data 2>/dev/null || true
	@rm -f apex_config.json apex_skills_manifest.json
	@echo "✅ Clean complete!"

## View Logs
apex-logs:
	@echo "📜 APEX Logs:"
	@docker-compose -f docker-compose.apex.yml logs -f --tail=100

## Help
help:
	@echo "🏛️ APEX NEXUS SUPREME - Available Commands:"
	@echo ""
	@echo "  make apex-all       - Deploy everything (recommended)"
	@echo "  make apex-deploy    - Deploy APEX architecture"
	@echo "  make apex-test      - Run integration tests"
	@echo "  make apex-monitor   - Launch monitoring dashboards"
	@echo "  make apex-status    - Check system status"
	@echo "  make apex-clean     - Clean everything"
	@echo "  make apex-logs      - View system logs"
	@echo ""
	@echo "📄 Documentation: docs/ARCHITECTURE.md"
	@echo "🐞 Issues: https://github.com/GlacierEQ/APEX-NEXUS-SUPREME/issues"
