import flet as ft

def criar_cabecalho():
    """Gera o título e subtítulo na parte superior do aplicativo."""
    return ft.Column(
        controls=[
            ft.Text("Scanner de Entrega", size=24, weight=ft.FontWeight.BOLD),
            ft.Text(
                "Alinhe o código de barras no quadrado abaixo",
                size=14,
                color=ft.Colors.GREY_400,
            ),
        ],
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
    )

def criar_area_scanner():
    """Gera a área da câmera com a máscara/quadrado verde sobreposta."""
    return ft.Stack(
        controls=[
            # 1. Câmera ao fundo (ocupa o espaço do container)
            ft.MobileCamera(
                expand=True,
                aspect_ratio=1.0,  # Proporção quadrada para o feed
            ),
            # 2. Máscara visual do scanner (o retângulo verde centralizado)
            ft.Container(
                content=ft.Container(
                    border=ft.border.all(2, ft.Colors.GREEN_ACCENT_400),
                    border_radius=12,
                    width=250,
                    height=150,
                ),
                alignment=ft.alignment.center,
                expand=True,
                # Deixa o fundo levemente escurecido fora do quadrado de foco
                bgcolor=ft.Colors.with_opacity(0.3, ft.Colors.BLACK),
            ),
        ],
        width=320,
        height=400,
    )