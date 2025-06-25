using UnityEngine;

public class SpellCaster : MonoBehaviour
{
    public SpellObject[] spellbook; // Assign in Inspector

    void Update()
    {
        if (InputManager.Instance.Spell1Pressed)
        {
            SpellObject spell = spellbook[0];
            SpellFactory.CastSpell(spell, transform);
        }

        if (InputManager.Instance.Spell2Pressed)
        {
            SpellObject spell = spellbook[1];
            SpellFactory.CastSpell(spell, transform);
        }
    }
}
