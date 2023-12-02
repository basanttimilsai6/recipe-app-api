from django.test import SimpleTestCase
from . import calc


class TestMy(SimpleTestCase):
    def test(self):
        res = calc.add(4, 5)
        self.assertEqual(res, 9)
