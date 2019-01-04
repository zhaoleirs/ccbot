using System;
using System.IO;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.CustomClass.Objects;

namespace something
{
    internal static class Constants
    {
        public static readonly Version Release = new Version(0, 1);

        public const string Name = "Bulwark";
        public const byte Class = PlayerClass.Warrior;

        public static readonly string[] TalentStrings =
        {
            "3532502135251050010503000000000000000000000000000000"
        };
    }

    public class Bulwark : CustomClass
    {

        private bool useCharge=true;
        private bool ShootTarget=false;
        public Bulwark()
        {
           // this.talentManager = new TalentManager(this.Player);
        }

        public override byte DesignedForClass
        {
            get { return Constants.Class; }
        }

        public override string CustomClassName
        {
            get { return string.Format("{0} {1}", Constants.Name, Constants.Release); }
        }
		
		private bool _pullRanged = false;

        private bool TargetCanBleed()
        {
            return (this.Target.CreatureType != CreatureType.Elemental && this.Target.CreatureType != CreatureType.Mechanical);
        }

        public override void PreFight()
        {
			if (!this.Player.GotBuff("Battle Stance"))
            {
                this.Player.Cast("Battle Stance");
            }
             if(useCharge){
                this.Player.Attack();
            }
        }
        private void Shoot(){
            if(!ShootTarget){
                // this.Player.DoString(equipAmmo);
                // this.Player.DoString("CastSpellByName('Shoot Bow')");
                ShootTarget=true;
                //this.Player.DoString("DEFAULT_CHAT_FRAME:AddMessage('Shoot')");
            }
        }
         public override void MoveTarget(){
            if(useCharge){
                if (this.Player.GetSpellRank("Charge") != 0&& this.Player.CanUse("Charge"))
                {
                    this.Player.Cast("Charge");
                }
            }else{
                if(Target.HealthPercent==0){
                    this.SetCombatDistance(28);
                }
            }

             if (this.Player.GetSpellRank("Overpower") != 0)
            {
                if (this.Player.CanOverpower)
                {
                    if (this.Player.Rage >= 5)
                        Player.Cast("Overpower");

                }
            }
        }
        public override void Fight()
        {   
            if(Player.ItemCount("Big-mouth Clam")>0){
                Player.UseItem("Big-mouth Clam"); 
                LootAll();
            }
             if(!useCharge){
                if(Target.HealthPercent<97||Target.DistanceToPlayer<=4){
                    this.SetCombatDistance(4);
                    ShootTarget=false;
                    this.Player.Attack();
                }else{
                    Shoot();
                }
             }else{
                this.Player.Attack();
             }
            // if (this.Player.GetSpellRank("Berserker Rage") != 0 && this.Player.CanUse("Berserker Rage"))
            // {
            //     this.Player.Cast("Berserker Rage");
            // }
            if (this.Player.GetSpellRank("Bloodrage") != 0 && this.Player.CanUse("Bloodrage"))
            {
                this.Player.Cast("Bloodrage");
            }

            if (this.Player.GetSpellRank("Overpower") != 0)
            {
                if (this.Player.CanOverpower)
                {
                    if (this.Player.Rage >= 5)
                        Player.Cast("Overpower");

                }
            }

            if (this.Player.GetSpellRank("Rend") != 0 && this.Player.GotBuff("Battle Stance"))
            {
                if (TargetCanBleed() && !this.Target.GotDebuff("Rend") && this.Player.Rage >= 10 & this.Target.HealthPercent > 25)
                {
                    this.Player.Cast("Rend");
                    return;
                }
            }

            if (this.Player.GetSpellRank("Execute") != 0 && !this.Player.GotBuff("Defensive Stance"))
            {
                if (this.Target.HealthPercent <= 20 && Player.Rage >= 15)
                {
                    this.Player.Cast("Execute");
                    return;
                }
            }
             if (this.Player.GetSpellRank("Mocking Blow") != 0&&Player.CanUse("Mocking Blow")&&this.Player.Rage >= 10)
            {
                 Player.Cast("Mocking Blow");
            }
            if (this.Player.GetSpellRank("Battle Shout") != 0)
            {
                if (this.Player.Rage >= 10 && !this.Player.GotBuff("Battle Shout"))
                {
                    this.Player.Cast("Battle Shout");
                }
            }

            if (this.Player.Rage <= 40)
            {
                if (this.Player.GetSpellRank("Blood Rage") != 0 && this.Player.CanUse("Blood Rage"))
                {
                    this.Player.Cast("Blood Rage");
                }
                if (this.Player.GetSpellRank("Berserker Rage") != 0 && this.Player.CanUse("Berserker Rage") && this.Player.GotBuff("Berserker Stance"))
                {
                    this.Player.Cast("Berserker Rage");
                }
            }

           

            if (this.Player.GetSpellRank("Bloodthirst") != 0)
            {
                if (this.Player.CanUse("Bloodthirst") && this.Player.Rage >= 20)
                {
                    this.Player.Cast("Bloodthirst");
                    return;
                }
            }
            else if (this.Player.GetSpellRank("Mortal Strike") != 0)
            {
                if (this.Player.CanUse("Mortal Strike") && this.Player.Rage >= 20)
                {
                    this.Player.Cast("Mortal Strike");
                    return;
                }
            }
            else //Super low level 
            {
                
                if (this.Player.Rage >= 15)
                {
                    this.Player.Cast("Heroic Strike");
                }
            }




            if (this.Player.Rage >= 30)
            {
                if (this.Player.GetSpellRank("Mortal Strike") != 0)
                {
                    if (this.Player.CanUse("Mortal Strike"))
                    {
                        this.Player.Cast("Mortal Strike");
                        return;
                    }
                }
                if(this.Attackers.Count >= 2 ){
                    if ( this.Player.GetSpellRank("Sweeping Strikes") != 0&&Player.CanUse("Sweeping Strikes"))
                    {
                        this.Player.Cast("Sweeping Strikes");
                    }
                    if ( this.Player.GetSpellRank("Cleave") != 0)
                    {
                        this.Player.Cast("Cleave");
                    }
                }else
                {
                    this.Player.Cast("Heroic Strike");
                }
            }
        }
        public override void Rest()
        {
            if(this.Player.GotBuff("Eat"))return;
            base.Rest();
        }
        private string equipAmmo="local as = GetInventorySlotInfo('AmmoSlot') if (not GetInventoryItemTexture('player',as) and GetInventoryItemCount('player', as)==1) then for i=0,4 do for j=1,GetContainerNumSlots(i) do local n=GetContainerItemInfo(i,j) if n and string.find(n,'Ammo') then PickupContainerItem(i,j) EquipCursorItem(as) DEFAULT_CHAT_FRAME:AddMessage('equiq ammo') return end end end end";
        public override bool Buff()
        {   
            return true;
        }
    }
}